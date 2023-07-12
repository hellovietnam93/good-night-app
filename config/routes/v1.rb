# frozen_string_literal: true

namespace :v1 do
  resources :users, only: %i(index)
end
