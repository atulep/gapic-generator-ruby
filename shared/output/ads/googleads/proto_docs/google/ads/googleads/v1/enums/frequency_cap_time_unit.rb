# frozen_string_literal: true

# Copyright 2019 Google LLC
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

module Google
  module Ads
    module GoogleAds
      module V1
        module Enums
          # Container for enum describing the unit of time the cap is defined at.
          class FrequencyCapTimeUnitEnum
            include Google::Protobuf::MessageExts
            extend Google::Protobuf::MessageExts::ClassMethods

            # Unit of time the cap is defined at (e.g. day, week).
            module FrequencyCapTimeUnit
              # Not specified.
              UNSPECIFIED = 0

              # Used for return value only. Represents value unknown in this version.
              UNKNOWN = 1

              # The cap would define limit per one day.
              DAY = 2

              # The cap would define limit per one week.
              WEEK = 3

              # The cap would define limit per one month.
              MONTH = 4
            end
          end
        end
      end
    end
  end
end