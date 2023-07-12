# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  def draw routes_name
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end

  namespace :api, format: :json do
    draw :v1
  end
end
