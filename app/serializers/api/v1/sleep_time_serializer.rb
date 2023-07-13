# frozen_string_literal: true

module Api
  module V1
    class SleepTimeSerializer < BaseSerializer
      attributes :id, :sleep_time, :wake_up_time

      belongs_to :user
    end
  end
end
