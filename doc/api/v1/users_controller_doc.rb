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
      param :page, Integer, require: false
      param :limit, Integer, require: false
      def index; end

      api :GET, "/v1/users/followers", "get all followers of current user"
      param_group :authorization
      param :page, Integer, require: false
      param :limit, Integer, require: false
      def followers; end

      api :GET, "/v1/users/followees", "get all followees of current user"
      param_group :authorization
      param :page, Integer, require: false
      param :limit, Integer, require: false
      def followees; end

      api :POST, "/v1/users/:id/follow", "follow user"
      param_group :authorization
      param :id, String, require: true, desc: "user id need to follow"
      def follow; end

      api :POST, "/v1/users/:id/unfollow", "unfollow user"
      param_group :authorization
      param :id, String, require: true, desc: "user id need to unfollow"
      def unfollow; end
    end
  end
end
