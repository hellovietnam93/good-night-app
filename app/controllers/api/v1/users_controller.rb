# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include UsersControllerDoc

      before_action :skip_authorize_permission

      def index
        render_jsonapi User.all
      end

      def followers
        render_jsonapi current_user.followers(User)
      end

      def followees
        render_jsonapi current_user.followees(User)
      end

      def follow
        raise ::Api::Error::SelfFollow if current_user.current_user?(user)
        raise ::Api::Error::Followed if current_user.follows?(user)

        current_user.follow!(user)
        render_jsonapi current_user
      end

      def unfollow
        raise ::Api::Error::NotFollowed unless current_user.follows?(user)

        current_user.unfollow!(user)
        render_jsonapi current_user
      end

      private

      def user
        @user ||= User.find params[:id]
      end
    end
  end
end
