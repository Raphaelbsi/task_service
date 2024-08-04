source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.8'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.5.3'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# rspec-rails is a testing framework for Rails 5+.
gem 'rspec-rails', '~> 6.1', '>= 6.1.3'

# factory_bot_rails provides integration between factory_bot and rails 5.0 or newer
gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'

# Alias gem for httparty
gem 'httpparty', '~> 0.2.0'

# Nokogiri (鋸) makes it easy and painless to work with XML and HTML from Ruby.
gem 'nokogiri', '~> 1.16', '>= 1.16.7'

# Selenium implements the W3C WebDriver protocol to automate popular browsers.
gem 'selenium-webdriver', '~> 4.23'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
