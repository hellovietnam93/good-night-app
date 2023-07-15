# frozen_string_literal: true

module Api
  module V1
    class SleepTimesController < ApplicationController
      include SleepTimesControllerDoc

      def index
        user = params[:user_id].blank? ? current_user : User.find(params[:user_id])
        render_jsonapi set_resources(user.sleep_times.order(created_at: :desc))
      end

      def followees
        sleep_times = SleepTime.where.not(user_id: current_user.id).order(created_at: :desc)
        render_jsonapi set_resources(sleep_times, action: :read)
      end

      def create
        sleep_time = current_user.sleep_times.new sleep_time_params
        sleep_time = set_resource(sleep_time)

        if sleep_time.save
          render_jsonapi sleep_time
        else
          render_error sleep_time.errors
        end
      end

      def show
        sleep_time = set_resource(SleepTime.find(params[:id]))

        render_jsonapi sleep_time
      end

      private

      def sleep_time_params
        params.require(:sleep_record).permit(::SleepTime::CREATE_PARAMS)
      end
    end
  end
end
