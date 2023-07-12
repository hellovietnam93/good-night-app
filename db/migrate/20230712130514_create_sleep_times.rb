# frozen_string_literal: true

class CreateSleepTimes < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_times do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :sleep_time
      t.datetime :wake_up_time

      t.timestamps
    end
  end
end
