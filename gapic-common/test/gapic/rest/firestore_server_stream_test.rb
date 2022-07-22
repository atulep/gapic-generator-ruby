
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

#
# Tests for the REST server stream.
#
class FirestoreServerStreamTest < Minitest::Test
  def test_array_enumerable_stream
    enumerable = [
      "[",
      "{",
      "\"foo\":1",
      "}",
      ",",
      "{",
      "\"bar\":1",
      "}",
      "]"
    ].to_enum

    rest_stream = Gapic::Rest::ServerStream.new(
      enumerable
    )
    assert_equal rest_stream.count, 2
  end

  # Example client illustrating how final Ruby client code will be generated.
  class FirestoreClient
    def initialize
      @endpoint = "https://firestore.googleapis.com/v1/projects/client-debugging/databases/(default)/documents:runQuery"
      @conn = Faraday.new url: @endpoint do |conn|
          conn.headers = { "Content-Type" => "application/json" }
          conn.request :google_authorization,  ::Google::Auth::Credentials.default
          conn.request :retry
          conn.response :raise_error
          conn.adapter :net_http
      end
    end

    # Example method for server streaming code generation.
    def runQuery request
      fiber = Fiber.new do 
        @conn.post(@endpoint, request) do |req|
          req.options.on_data = Proc.new do |chunk, overall_received_bytes|
            Fiber.yield chunk
          end
        end
        nil
      end
      rest_stream = Gapic::Rest::ServerStream.new(
        Gapic::Rest::FiberEnumerable.new(fiber)
      )
      return rest_stream
    end
  end  

  def test_fiber_enumerable_stream
    request = <<-JSON 
    { parent: "projects/client-debugging/databases/(default)/documents",
      structuredQuery: {
        endAt: {
          before: true,
          values: [{
            referenceValue: "projects/client-debugging/databases/(default)/documents/node_5.0.2_0KwCDFyz5uZYxCg3QWPh/DHascZz7jFwjUezanOjK"
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
    firestore = FirestoreClient.new
    rest_stream = firestore.runQuery(request)
    assert_equal rest_stream.count, 77
  end
end