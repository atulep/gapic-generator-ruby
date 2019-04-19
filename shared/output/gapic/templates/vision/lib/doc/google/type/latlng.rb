# frozen_string_literal: true

# The MIT License (MIT)
#
# Copyright <YEAR> <COPYRIGHT HOLDER>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

raise "This file is for documentation purposes only."

module Google
  module Type
    # An object representing a latitude/longitude pair. This is expressed as a pair
    # of doubles representing degrees latitude and degrees longitude. Unless
    # specified otherwise, this must conform to the
    # <a href="http://www.unoosa.org/pdf/icg/2012/template/WGS_84.pdf">WGS84
    # standard</a>. Values must be within normalized ranges.
    #
    # Example of normalization code in Python:
    #
    #     def NormalizeLongitude(longitude):
    #       """Wraps decimal degrees longitude to [-180.0, 180.0]."""
    #       q, r = divmod(longitude, 360.0)
    #       if r > 180.0 or (r == 180.0 and q <= -1.0):
    #         return r - 360.0
    #       return r
    #
    #     def NormalizeLatLng(latitude, longitude):
    #       """Wraps decimal degrees latitude and longitude to
    #       [-90.0, 90.0] and [-180.0, 180.0], respectively."""
    #       r = latitude % 360.0
    #       if r <= 90.0:
    #         return r, NormalizeLongitude(longitude)
    #       elif r >= 270.0:
    #         return r - 360, NormalizeLongitude(longitude)
    #       else:
    #         return 180 - r, NormalizeLongitude(longitude + 180.0)
    #
    #     assert 180.0 == NormalizeLongitude(180.0)
    #     assert -180.0 == NormalizeLongitude(-180.0)
    #     assert -179.0 == NormalizeLongitude(181.0)
    #     assert (0.0, 0.0) == NormalizeLatLng(360.0, 0.0)
    #     assert (0.0, 0.0) == NormalizeLatLng(-360.0, 0.0)
    #     assert (85.0, 180.0) == NormalizeLatLng(95.0, 0.0)
    #     assert (-85.0, -170.0) == NormalizeLatLng(-95.0, 10.0)
    #     assert (90.0, 10.0) == NormalizeLatLng(90.0, 10.0)
    #     assert (-90.0, -10.0) == NormalizeLatLng(-90.0, -10.0)
    #     assert (0.0, -170.0) == NormalizeLatLng(-180.0, 10.0)
    #     assert (0.0, -170.0) == NormalizeLatLng(180.0, 10.0)
    #     assert (-90.0, 10.0) == NormalizeLatLng(270.0, 10.0)
    #     assert (90.0, 10.0) == NormalizeLatLng(-270.0, 10.0)
    # @!attribute [rw] latitude
    #   @return [Float]
    #     The latitude in degrees. It must be in the range [-90.0, +90.0].
    # @!attribute [rw] longitude
    #   @return [Float]
    #     The longitude in degrees. It must be in the range [-180.0, +180.0].
    class LatLng
      include Google::Protobuf::MessageExts
      extend Google::Protobuf::MessageExts::ClassMethods
    end
  end
end
