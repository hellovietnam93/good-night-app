# frozen_string_literal: true

module Api
  module V1
    module SleepTimesControllerDoc
      extend Apipie::DSL::Concern

      def_param_group :authorization do
        header "X_AUTH_TOKEN", "access token"
        error code: 401, desc: "Unauthorized"
      end

      api :POST, "/v1/sleep_times", "add new sleep time record"
      param_group :authorization
      param :sleep_time, Hash do
        param :sleep_time, String, "use ISO8601 format. Ex: '2023-07-13T13:43:14Z'"
        param :wake_up_time, String, "use ISO8601 format. Ex: '2023-07-13T13:43:14Z'"
      end
      def index; end
    end
  end
end
