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

##
# Tests for the REST paged enumerables
#
class RestServerStreamTest < Minitest::Test
  ##
  # Tests that a `ServerStream` can enumerate all resources via `each`
  #
  def test_enumerates_all_resources
    api_responses = [
      [
        Gapic::Examples::User.new(name: "foo"),
        Gapic::Examples::User.new(name: "bar")
      ],
      [
        Gapic::Examples::User.new(name: "baz"),
        Gapic::Examples::User.new(name: "bif")
      ]
    ]

    rest_stream_enum = Gapic::Rest::ServerStream.new(
      api_responses
    )
    assert_equal %w[foo bar baz bif], rest_stream_enum.each.map(&:name)
  end
end
