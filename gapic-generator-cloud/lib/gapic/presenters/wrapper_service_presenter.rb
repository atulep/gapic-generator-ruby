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

require "gapic/presenters"
require "gapic/presenters/wrapper_service_rest_presenter"
require "gapic/ruby_info"

module Gapic
  module Presenters
    ##
    # A presenter for wrapper services.
    #
    class WrapperServicePresenter < ServicePresenter
      def initialize *args, **kwargs
        super(*args, **kwargs)
        @rest = WrapperServiceRestPresenter.new self, @api
      end

      def factory_method_name
        @factory_method_name ||= begin
          method_name = ActiveSupport::Inflector.underscore name
          suffix = gem.factory_method_suffix
          method_name = "#{method_name}#{suffix}" unless method_name.end_with? suffix
          method_name = "#{method_name}_client" if Gapic::RubyInfo.excluded_method_names.include? method_name
          method_name
        end
      end

      ##
      # Returns this service presenter if there is a grpc client. Otherwise,
      # returns the corresponding rest service presenter if there isn't a grpc
      # client but there is a rest client. Otherwise, returns nil if there is
      # neither client.
      #
      # @return [WrapperServicePresenter,WrapperServiceRestPresenter,nil]
      #
      def usable_service_presenter
        if @api.generate_grpc_clients?
          self
        elsif @api.generate_rest_clients? && methods_rest_bindings?
          rest
        end
      end

      def create_client_call
        "#{gem.namespace}.#{factory_method_name}"
      end

      def configure_client_call
        "#{gem.namespace}.configure"
      end

      def credentials_class_xref
        "`#{credentials_name_full}`"
      end
    end
  end
end
