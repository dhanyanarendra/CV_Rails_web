source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'kaminari'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem "socialization"
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc
# Gem for postgres sql
gem 'pg'

gem 'kaminari'

# Rack::Cors provides support for Cross-Origin Resource Sharing (CORS) for Rack compatible web applications.
gem 'rack-cors', :require => 'rack/cors'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'carrierwave', '~> 0.10.0'
gem 'fog', '~> 1.34.0'
gem "mini_magick",'~> 4.3'
gem 'net-ssh'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', github: "capistrano/rbenv"
end

group :development, :test do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # In order to follow Test Driven Development, we use Rspec . rspec-rails is a testing framework
  gem 'rspec-rails', '~> 3.0'
  gem "codeclimate-test-reporter", group: :test, require: nil
  # Use binding.pry for debugging
  gem 'pry'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'shoulda'
  gem 'timecop'
  gem 'database_cleaner'
  gem 'faker'
end

