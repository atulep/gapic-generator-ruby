
# frozen_string_literal: true

# Copyright 2021 Google LLC
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

require "test_helper"
require "faraday"
require "pp"
require 'pry'
require "googleauth"

##
# Tests for the REST paged enumerables
#
class FaradayE2ETest < Minitest::Test
  ##
  # Tests that a `ServerStream` can enumerate all resources via `each`
  #
  def test_enumerates_all_resources
    endpoint = "https://firestore.googleapis.com/v1/projects/client-debugging/databases/(default)/documents:runQuery"

    conn = Faraday.new url: @endpoint do |conn|
        conn.headers = { "Content-Type" => "application/json" }
        conn.request :google_authorization,  ::Google::Auth::Credentials.default
        conn.request :retry
        conn.response :raise_error
        conn.adapter :net_http
    end

    # A buffer to store the streamed data
    streamed = []

    request = <<-JSON 
    { parent: "projects/client-debugging/databases/(default)/documents",
      structuredQuery: {
        endAt: {
          before: true,
          values: [{
            referenceValue: "projects/client-debugging/databases/(default)/documents/node_5.0.2_0KwCDFyz5uZYxCg3QWPh/VZkD7W3eKKQU11aVufpx"
          }]
        },
        from: [{
          allDescendants: true,
          collectionId: "node_5.0.2_0KwCDFyz5uZYxCg3QWPh",
        }],
        orderBy: [{
          direction: 'ASCENDING',
          field: {
            fieldPath: '__name__'
          }
        }],
      }
    }
    JSON
    # # old = "{structuredQuery:{from:{collectionId:'large'}}}"
    # conn.post(endpoint, request) do |req|
    #   # Set a callback which will receive tuples of chunk Strings
    #   # and the sum of characters received so far
    #   req.options.on_data = Proc.new do |chunk, overall_received_bytes|
    #       puts "Received #{overall_received_bytes} characters"
    #       streamed << chunk
    #       #sleep(3)
    #       pp "@@@Chunk in conn:"
    #       pp chunk
    #       # Fiber.yield chunk
    #       #Enumerable.add_chunk(chunk)
    #   end
    # end


    fiber = Fiber.new do 
      # old = "{structuredQuery:{from:{collectionId:'large'}}}"
      conn.post(endpoint, request) do |req|
        # Set a callback which will receive tuples of chunk Strings
        # and the sum of characters received so far
        req.options.on_data = Proc.new do |chunk, overall_received_bytes|
            puts "Received #{overall_received_bytes} characters"
            streamed << chunk
            #sleep(3)
            # pp "@@@Chunk in conn:"
            # pp chunk
            Fiber.yield chunk
            #Enumerable.add_chunk(chunk)
        end
      end
    end
    #binding.pry
    puts "---------"
    begin
      while true
        chunk = fiber.resume
        puts "@@@Chunk="
        pp chunk
      end
    rescue FiberError
      puts "fiber ends."
    end
    puts "---------"
    streamed.each do |chunk|
      pp chunk.length
    end
    pp streamed.count
  end
end


