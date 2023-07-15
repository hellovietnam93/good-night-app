# frozen_string_literal: true

module Api
  module V1
    module SleepTimesControllerDoc
      extend Apipie::DSL::Concern

      def_param_group :authorization do
        header "X_AUTH_TOKEN", "access token"
        error code: 401, desc: "Unauthorized"
      end

      api :GET, "/v1/sleep_times?user_id=:user_id", "get list sleep times"
      param_group :authorization
      param :user_id, String, require: false, desc: "user id if want to list by user"
      def index; end

      api :GET, "/v1/sleep_times/followees", "get list sleep times of all followees"
      param_group :authorization
      param :start_time, String, require: false,
desc: "Format: ISO8601. Ex: '2023-07-13T13:43:14Z'. Default one week ago"
      param :end_time, String, require: false, desc: "Format: ISO8601. Ex: '2023-07-13T13:43:14Z'. Default current time"
      def followees; end

      api :POST, "/v1/sleep_times", "add new sleep time record"
      param_group :authorization
      param :sleep_time, Hash do
        param :sleep_time, String, "use ISO8601 format. Ex: '2023-07-13T13:43:14Z'"
        param :wake_up_time, String, "use ISO8601 format. Ex: '2023-07-13T13:43:14Z'"
      end
      def create; end

      api :GET, "/v1/sleep_times/:id", "get a sleep time record"
      param_group :authorization
      param :id, String, require: true, desc: "sleep_time record id"
      def show; end
    end
  end
end
