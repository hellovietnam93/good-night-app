# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ApplicationController
      include ::Api::Helpers::Authentication
      include ::Api::JsonRender
      include ::Api::RescueExceptions
      include ::Api::Pagination

      before_action :authenticate_request!

      ###############################
      ############ private ##########
      ###############################

      private

      def authenticate_request!
        current_user
      end

      def current_user
        @current_user ||= token.user
      end

      def token
        raise ::Api::Error::MissingToken if request_token.nil?

        auth_token = UserToken.find_by(token: request_token)
        raise ::Api::Error::MissingToken if auth_token.nil?

        auth_token
      end

      def request_token
        @token ||= request.headers["X_AUTH_TOKEN"]
      end
    end
  end
end
