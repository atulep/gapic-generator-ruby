# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Gapic
  module Rest

    def use_server_stream
      ss = ServerStream.new 

      ss.each do |object|
        object*2
      end
    end

    class ServerStream
      include Enumerable

      # @return Enumberable<Object>
      attr_reader :body

      # @return Enumerable<Enumberable<Object>>
      attr_reader :bodies

      # @param bodies Enumerable<String>
      def initialize bodies
        @bodies = bodies
        @_level = 0
        @_obj = ""
        @_ready_objs = []
      end

      def next_json!
        for body in @bodies
          for char in body.split("")
            if char == "{"
              if @_level == 1
                @_obj = ""
              end
              if not @_in_string
                @_level += 1
              end
              @_obj += char
            elsif char == "}"
              @_obj += char
              if not @_in_string
                @_level -= 1
              end
              if not @_in_string and @_level == 1
                @_ready_objs.append(@_obj)
              end
            elsif char == '"'
              @_in_string = !@_in_string
              @_obj += char
            elsif char == "["
              if @_level == 0
                @_level += 1
              else
                @_obj += char
              end
            elsif char == "]"
              if @_level == 1
                @_level -= 1
              else
                @_obj += char
              end
            else
              @_obj += char
            end
          end
        end
      end

      ##
      # Iterate over the resources.
      #
      # @yield [Object] Gives the resource objects in the page.
      #
      # @return [Enumerator] if no block is provided
      #
      def each &block
        return enum_for :each unless block_given?
        loop do
          break if @_ready_objs.length > 0
          next_json!
        end
        yield @_ready_objs.shift
      end

      private

      # @yield [Page] Gives the pages in the stream.
      #
      # @return [Enumerator] if no block is provided
      #
      def each_body
        loop do
          break if @_ready_objs.length > 0
          next_json!
        end
        yield @_ready_objs.shift
      end
    end
  end
end
