# frozen_string_literal: true

namespace :v1 do
  resources :users, only: %i(index) do
    member do
      post :follow
      post :unfollow
    end
    collection do
      get :followers
      get :followees
    end
  end
  resources :sessions, only: %i(create)
  resources :sleep_times, only: %i(create index show) do
    collection do
      get :followees
    end
  end
end
