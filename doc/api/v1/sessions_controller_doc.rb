# frozen_string_literal: true

module Api
  module V1
    module SessionsControllerDoc
      extend Apipie::DSL::Concern

      api :POST, "/v1/sessions", "Sign in user"
      param :user, Hash do
        param :email, String
        param :password, String
      end
      def create; end
    end
  end
end
