# frozen_string_literal: true

FactoryBot.define do
  factory :sleep_time do
    user
    sleep_time { Time.current }
    wake_up_time { Time.current + 2.hours }
  end
end
