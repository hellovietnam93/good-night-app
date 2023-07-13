# frozen_string_literal: true

namespace :v1 do
  resources :users, only: %i(index)
  resources :sessions, only: %i(create)
  resources :sleep_times, only: %i(create)
end
