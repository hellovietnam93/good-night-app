# frozen_string_literal: true

FactoryBot.define do
  factory :sleep_time do
    user
    sleep_time { "2023-07-12 20:05:15" }
    wake_up_time { "2023-07-12 20:05:15" }
  end
end
