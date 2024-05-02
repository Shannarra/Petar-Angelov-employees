# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

# Bundle Rails
gem "rails"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", '~> 6.4.2'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire"s SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire"s modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails", "~> 2.1"

# Use Bootstrap
gem "bootstrap"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.12"

gem "brakeman"
gem "bundler-audit"

# Rubocop
gem "rubocop-rails"

# Javascript runtime using Node. Useful for Bootstrap
gem 'execjs'

# Useful to bootstrap authentication. https://stackoverflow.com/a/42190260/11542917
gem 'devise'

# Allows for fa icons usage in views.
gem 'font-awesome-rails', '~> 4.7.0'

# Authorization helpers gem, makes it easy to authorize and redirect
gem 'pundit'

# Pagination of tables or huge content
gem 'kaminari'

# Admin panel pages
# Remember to add '*= stub "active_admin" ' to application.scss to localy scope AA CSS from clashing with Bootstrap
gem 'activeadmin'

# File uploaders associated with models
gem 'carrierwave'

# Background workers
gem 'sidekiq'

# PDF generation
gem 'prawn'

# Generating fake data. Usually useful only on :development and :test group, but I need it to seed the prod data easily.
gem "faker"

group :development, :test do
  gem "factory_bot_rails"
  gem "pry"
  gem "rails_live_reload"
  gem "rspec-html-matchers"
  gem "rspec-rails"
  gem "rubocop-rspec"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Provides a REPL console upon a runtime error in webview
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
