# frozen_string_literal: true

source "https://rubygems.org"

gem "bootsnap", require: false
gem "bootstrap", "~> 5.3.3"
gem "draper"
gem "font-awesome-sass", "~> 6.5.2"
gem "importmap-rails"
gem "jbuilder"
gem "pagy"
gem "puma", ">= 5.0"
gem "rails", "~> 8.0.0"
gem "redis"
gem "sassc-rails"
gem "simple_form"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

# BackgroundJob and Scheduling
gem "sidekiq"
gem "sidekiq-scheduler"

# Database and Performance Tracking
gem "pg", "~> 1.1"
gem "pghero"

# Authentication
gem "devise"
gem "devise-jwt"

# ActiveAdmin
gem "activeadmin"
gem "activeadmin_addons"

# Performance and Error Tracking
gem "rollbar"
gem "scout_apm"

# Grape
gem "grape"
gem "grape-entity"
gem "grape-swagger"
gem "grape-swagger-entity"
gem "grape-swagger-rails"

group :development, :test do
  gem "byebug"
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "dotenv-rails"

  # Code Quality & Linting
  gem "rubocop-rails-suite", require: false

  # Rspec
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails", "~> 7.0.0"

  # Security
  gem "brakeman", require: false
  gem "bundler-audit", require: false
end

group :development do
  gem "web-console"

  # Performance
  gem "bullet"
  gem "rack-mini-profiler", require: false
end

group :test do
  gem "capybara"
  gem "rspec-sidekiq"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
end
