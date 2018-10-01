source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# use json web token
gem 'jwt', '~> 1.5', '>= 1.5.4'
gem "bigdecimal", ">= 1.3.2"
gem 'money-rails', '~>1'
# Use mongoid and autoinc and mongo
gem 'mongoid', '~> 6.4'
gem 'mongoid-autoinc'
gem 'mongo', '2.5.1'
gem 'mongoid_search'
gem 'mongoid-shell'
gem 'mongoid-compatibility'

#resque
gem 'resque-scheduler'
gem 'resque'
gem 'resque-web'

# cors gem
gem 'rack-cors', :require => 'rack/cors'

gem 'redis'

gem 'redis-namespace', '~> 1.5', '>= 1.5.3'

gem 'redis-rails'

gem 'redis-rack-cache'
# Use sqlite3 as the database for Active Record
# Use Puma as the app server
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
