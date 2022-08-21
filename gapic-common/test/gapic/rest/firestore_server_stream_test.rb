# frozen_string_literal: true

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

require "test_helper"
require "faraday"
require "pp"
require 'pry'
require "googleauth"

class MockProtobufClass
  def self.decode_json str
    return str
  end
end


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
      enumerable, MockProtobufClass,
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
      rest_stream = Gapic::Rest::ServerStream.new(
        Gapic::Rest::ThreadedFiberEnumerator.new do 
          runQuery_service_stub request do |req|
            req.options.on_data = Proc.new do |chunk, overall_received_bytes|
              Fiber.yield chunk
            end
          end
          nil
        end,
        MockProtobufClass,
      )
      return rest_stream
    end

    def runQuery_service_stub request, &block
      make_http_request :post, uri: @endpoint, body: request, params: [], &block
    end

    def make_http_request verb, uri:, body:, params:, &block
      block_really_given = block_given?
      @conn.send verb, uri do |req|
        req.params = params if params.any?
        req.body = body unless body.nil?
        block.call req if block_really_given
      end
    end
  end  

  def test_firestore_stream_in_thread
    request = <<-JSON 
    { parent: "projects/client-debugging/databases/(default)/documents",
      structuredQuery: {
        endAt: {
          before: true,
          values: [{
            referenceValue: "projects/client-debugging/databases/(default)/documents/ruby_enumberable_stream/tGmmVU9OCL3xRXhLokq9"
          }]
        },
        from: [{
          allDescendants: true,
          collectionId: "ruby_enumberable_stream",
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
    assert_equal 9, rest_stream.count
  end

  def test_firestore_stream_separate_thread
    request = <<-JSON 
    { parent: "projects/client-debugging/databases/(default)/documents",
      structuredQuery: {
        endAt: {
          before: true,
          values: [{
            referenceValue: "projects/client-debugging/databases/(default)/documents/ruby_enumberable_stream/tGmmVU9OCL3xRXhLokq9"
          }]
        },
        from: [{
          allDescendants: true,
          collectionId: "ruby_enumberable_stream",
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

    queue = Queue.new
    Thread.new do
      ix = rest_stream.count
      queue << ix
    end

    count = queue.pop
    assert_equal 9, count
  end
end
