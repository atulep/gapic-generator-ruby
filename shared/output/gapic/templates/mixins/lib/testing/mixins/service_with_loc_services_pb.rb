# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: testing/mixins/service_with_loc.proto for package 'Testing.Mixins'

require 'grpc'
require 'testing/mixins/service_with_loc_pb'

module Testing
  module Mixins
    module FirstServiceWithLoc
      class Service

        include GRPC::GenericService

        self.marshal_class_method = :encode
        self.unmarshal_class_method = :decode
        self.service_name = 'testing.mixins.FirstServiceWithLoc'

        rpc :Method, ::Testing::Mixins::Request, ::Testing::Mixins::Response
      end

      Stub = Service.rpc_stub_class
    end
    module SecondServiceWithLoc
      class Service

        include GRPC::GenericService

        self.marshal_class_method = :encode
        self.unmarshal_class_method = :decode
        self.service_name = 'testing.mixins.SecondServiceWithLoc'

        rpc :Method, ::Testing::Mixins::Request, ::Testing::Mixins::Response
      end

      Stub = Service.rpc_stub_class
    end
  end
end