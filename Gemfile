source 'http://rubygems.org'

gem 'rails', '3.1.0.rc1'
gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
#
gem 'sass'
gem 'haml'
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'

# Rake 0.9 breaks Rails 3.1 | http://twitter.com/#!/dhh/status/71966528744071169
gem "rake", "0.8.7"


group(:development, :test) do

  gem 'rspec-rails', '>= 2.6.1.beta1'

  gem 'cucumber-rails'
  gem 'pickle'

  gem 'timecop'
  gem 'autotest'
  gem 'launchy'
  gem 'database_cleaner'
  gem "factory_girl_rails"
  gem 'timecop'

  gem 'prawn'

  gem 'email_spec'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-spork'
  gem 'libnotify'

  gem 'spork'

  # gem 'silent-postgres'
end

group :development do
  gem 'capistrano'
end


# quit warnings by rack about "regexp match /.../n against to UTF-8 string"
gem "escape_utils"


gem 'inherited_resources'
gem 'simple_form'

gem "nifty-generators"

gem 'mt940_parser', :require => 'mt940'
