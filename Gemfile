# frozen_string_literal: true

source "https://rubygems.org"

gem "bootsnap", require: false
gem "bootstrap", "~> 5.3.3"
gem "draper"
gem "font-awesome-sass", "~> 6.5.2"
gem "importmap-rails"
gem "jbuilder"
gem "kaminari"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rails", "~> 7.2.1"
gem "sassc-rails"
gem "scout_apm"
gem "sidekiq"
gem "simple_form"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

# Authentication
gem "devise"
gem "devise-jwt"

# Grape
gem "grape", "~> 2.1.3"
gem "grape-entity"
gem "grape-swagger"
gem "grape-swagger-entity"
gem "grape-swagger-rails"

group :development, :test do
  gem "byebug"
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "dotenv-rails"

  # Code Quality & Linting
  gem "rubocop", require: false
  # gem "rubocop-rails-omakase", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-faker", require: false
  gem "rubocop-migration", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false

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
