# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'bootsnap', require: false
gem 'dotenv-rails'
gem 'dry-validation'
gem 'pg'
gem 'puma'
gem 'rails'

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'factory_bot_rails'
  gem 'fasterer'
  gem 'ffaker'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rails_best_practices'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'timecop'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
