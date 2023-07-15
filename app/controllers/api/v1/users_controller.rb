# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include UsersControllerDoc

      before_action :skip_authorize_permission

      def index
        list_users(User.all)
      end

      def followers
        list_users(current_user.followers(User))
      end

      def followees
        list_users(current_user.followees(User))
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

      def list_users users
        pagy_info, users = paginate users
        render_jsonapi users, meta: pagy_info
      end
    end
  end
end
