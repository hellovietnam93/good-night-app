# frozen_string_literal: true

module Api
  module V1
    module UsersControllerDoc
      extend Apipie::DSL::Concern

      def_param_group :authorization do
        header "X_AUTH_TOKEN", "access token"
        error code: 401, desc: "Unauthorized"
      end

      api :GET, "/v1/users", "get all users"
      param_group :authorization
      def index; end
    end
  end
end
