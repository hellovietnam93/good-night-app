# frozen_string_literal: true

FactoryBot.define do
  factory :user_token do
    user
    user_agent { "MyString" }
  end
end
