# frozen_string_literal: true

class AddDurationToSleepTimes < ActiveRecord::Migration[7.0]
  def change
    add_column :sleep_times, :duration, :integer
    SleepTime.find_each do |sleep_time|
      sleep_time.update duration: sleep_time.wake_up_time - sleep_time.sleep_time
    end
  end
end
