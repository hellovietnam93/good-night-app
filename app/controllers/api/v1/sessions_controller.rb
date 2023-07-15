# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_request!
      before_action :skip_authorize_permission

      include SessionsControllerDoc

      def create
        user = User.find_by_email(email.to_s.downcase)
        return render_invalid_email_or_password unless user

        if user.valid_password?(password)
          user_token = user.user_tokens.create!
          render_jsonapi user_token
        else
          render_invalid_email_or_password
        end
      end

      private

      def sign_in_params
        params.require(:user).permit(::User::SIGN_IN_PARAMS)
      end

      def email
        sign_in_params[:email]
      end

      def password
        sign_in_params[:password]
      end

      def render_invalid_email_or_password
        raise ::Api::Error::AuthenticationFailed
      end
    end
  end
end
