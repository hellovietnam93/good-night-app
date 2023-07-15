# frozen_string_literal: true

class SleepTime < ApplicationRecord
  ###
  # constants
  CREATE_PARAMS = %i(sleep_time wake_up_time).freeze

  ###
  # associations
  belongs_to :user

  ###
  # validations
  validates :sleep_time, :wake_up_time, presence: true
  validate :valid_time_range
  validate :no_overlap, on: :create

  ###
  # scopes
  scope :in_range, lambda { |start_time, end_time|
    where(sleep_time: start_time..end_time)
  }

  ###
  # callbacks
  before_validation :set_duration

  ################################
  ############ private ###########
  ################################

  private

  def valid_time_range
    return unless sleep_time && wake_up_time && sleep_time >= wake_up_time

    errors.add(:base, "Wake up time must be after sleep time")
  end

  def no_overlap
    if SleepTime.where(user_id:).where("(sleep_time, wake_up_time) OVERLAPS (?, ?)", sleep_time, wake_up_time).exists?
      errors.add(:base, "Sleep time overlaps with an existing record")
    end
  end

  def set_duration
    self.duration = wake_up_time.to_i - sleep_time.to_i
  end
end
