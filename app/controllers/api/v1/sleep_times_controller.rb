# frozen_string_literal: true

module Api
  module V1
    class SleepTimesController < ApplicationController
      include SleepTimesControllerDoc

      def index
        user = params[:user_id].blank? ? current_user : User.find(params[:user_id])
        list_sleep_times(set_resources(user.sleep_times.order(created_at: :desc)))
      end

      def followees
        sleep_times = SleepTime.in_range(start_time, end_time)
                               .where.not(user_id: current_user.id)
                               .order(duration: :desc)
        list_sleep_times(set_resources(sleep_times, action: :read))
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

      # Default filter for start time is 1 week ago
      # Start time must be in iso8601 format
      def start_time
        return 1.week.ago.beginning_of_week if params[:start_time].blank?

        begin
          Time.iso8601(params[:start_time])
        rescue ArgumentError
          raise ::Api::Error::InvalidTimeRange, "start_time"
        end
      end

      # Default filter for end time is current time
      # End time must be in iso8601 format
      def end_time
        return Time.current if params[:end_time].blank?

        begin
          Time.iso8601(params[:end_time])
        rescue ArgumentError
          raise ::Api::Error::InvalidTimeRange, "end_time"
        end
      end

      def list_sleep_times sleep_times
        pagy_info, sleep_times = paginate sleep_times
        render_jsonapi sleep_times, meta: pagy_info
      end
    end
  end
end
