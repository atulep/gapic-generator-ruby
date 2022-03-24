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

      # @param bodies Enumerable<Enumberable<Object>>
      def initialize bodies
        @bodies = bodies
        next_body!
      end

      def next_body!
        @body = bodies.shift
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

        each_body do |body|
          body.each(&block)
        end
      end

      private

      # @yield [Page] Gives the pages in the stream.
      #
      # @return [Enumerator] if no block is provided
      #
      def each_body
        loop do
          break if @body.nil?
          yield @body
          next_body!
        end
      end
    end
  end
end
