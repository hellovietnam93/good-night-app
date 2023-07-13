# frozen_string_literal: true

module Api
  module V1
    class SleepTimesController < ApplicationController
      include SleepTimesControllerDoc

      def create
        sleep_time = current_user.sleep_times.new sleep_time_params

        if sleep_time.save
          render_jsonapi sleep_time
        else
          render_error sleep_time.errors
        end
      end

      private

      def sleep_time_params
        params.require(:sleep_record).permit(::SleepTime::CREATE_PARAMS)
      end
    end
  end
end
