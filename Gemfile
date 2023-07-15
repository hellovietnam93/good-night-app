# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'apipie-rails', '~> 1.2', '>= 1.2.1'
gem 'bootsnap', require: false
gem 'devise', '~> 4.9', '>= 4.9.2'
gem 'jsonapi-serializer', '~> 2.2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'rails', '~> 7.0.4', '>= 7.0.4.3'
gem "settingslogic", "~> 2.0", ">= 2.0.9"
gem 'socialization', '~> 2.0', '>= 2.0.1'
gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)

group :development, :test do
  gem 'brakeman', '~> 6.0', require: false
  gem 'bundler-audit', '~> 0.9.1'
  gem 'debug', platforms: %i(mri mingw x64_mingw)
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.2'
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.3'
  gem 'rubocop', '~> 1.54', '>= 1.54.1', require: false
  gem 'rubocop-checkstyle_formatter', '~> 0.6.0', require: false
  gem 'rubocop-rails', '~> 2.20', '>= 2.20.2', require: false
  gem 'rubocop-rspec', '~> 2.22', require: false
  gem 'shoulda-matchers', '~> 5.3'
  gem 'simplecov', '~> 0.22.0'
end
