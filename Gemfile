source 'http://rubygems.org'

gem 'rails', '3.0.1'
gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'


group(:development, :test) do

  gem 'rspec-rails', '~> 2.0.0.beta.19'

  # To get a detailed overview about what queries get issued and how long they take
  # have a look at rails_metrics. Once you bundled it, you can run
  #
  #   rails g rails_metrics Metric
  #   rake db:automigrate
  #
  # to generate a model that stores the metrics. You can access them by visiting
  #
  #   /rails_metrics
  #
  # in your rails application.

  # gem 'rails_metrics', '~> 0.1', :git => 'git://github.com/engineyard/rails_metrics'

  gem 'capybara', '>= 0.3.8'
  gem 'cucumber', '>= 0.9.3', :git => 'git://github.com/aslakhellesoy/cucumber.git'
  gem 'cucumber-rails', '>= 0.3.3', :git => 'git://github.com/aslakhellesoy/cucumber-rails.git'
  gem 'pickle'
  gem 'timecop'
  gem 'autotest'
  gem 'launchy'
  gem 'database_cleaner', '>= 0.5.2'
  gem "factory_girl_rails", ">= 1.0.0"
  gem 'spork', '0.9.0.rc2'
  gem 'timecop'

  gem 'prawn'

  gem 'email_spec'

  # gem 'silent-postgres'
end

group :development do
  gem 'capistrano'
end


# quit warnings by rack about "regexp match /.../n against to UTF-8 string"
gem "escape_utils"


gem 'andand'
gem 'haml-rails', '>= 0.0.2'
gem 'inherited_resources'
gem 'simple_form'

gem "nifty-generators"
gem 'bistro_car'

gem 'mt940_parser', :require => 'mt940'
