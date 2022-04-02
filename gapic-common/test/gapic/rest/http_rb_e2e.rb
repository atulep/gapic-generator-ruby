
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
require "http"
require "pp"
require 'pry'

##
# Tests for the REST paged enumerables
#
class FaradayE2ETest < Minitest::Test
  ##
  # Tests that a `ServerStream` can enumerate all resources via `each`
  #
  def test_enumerates_all_resources
    endpoint = "https://firestore.googleapis.com/v1/projects/its-april/databases/(default)/documents:runQuery"

    # conn = Faraday.new url: @endpoint do |conn|
    #     conn.headers = { "Content-Type" => "application/json" }
    #     conn.request :retry
    #     conn.response :raise_error
    #     conn.adapter :net_http
    # end

    # A buffer to store the streamed data
    streamed = []

    res = HTTP.post(endpoint, :json => {:structuredQuery => { :from => {:collectionId => 'large'}}})
    puts "Body:"
    body=res.body
    puts "Running res.body.readpartial: ----"
    while true
        puts "Received:"
        chunk = body.readpartial
        pp chunk
        if chunk == nil
            break
        end
    end
    # res = conn.post(endpoint, "{structuredQuery:{from:{collectionId:'large'}}}") do |req|
    #     # Set a callback which will receive tuples of chunk Strings
    #     # and the sum of characters received so far
    #     req.options.on_data = Proc.new do |chunk, overall_received_bytes|
    #         puts "Received #{overall_received_bytes} characters"
    #         streamed << chunk
    #         # sleep(3)
    #         puts chunk
    #         #Enumerable.add_chunk(chunk)
    #     end
    # end
    #binding.pry
    # puts "---------"
    # pp res
    # puts "---------"
    # # Joins all response chunks together
    # streamed.join
  end
end


