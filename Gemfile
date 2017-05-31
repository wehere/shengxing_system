# source 'https://rubygems.org'
#source 'https://gems.ruby-china.org/'
source 'https://ruby.taobao.org/'

ruby '2.3.1'
#ruby-gemset=shengxing

gem 'rails', '4.2.4'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'devise', '=3.5.2'
gem 'mysql2', '0.3.18'
gem 'will_paginate','3.0.7'
gem 'bootstrap-will_paginate','0.0.10'
gem 'therubyracer',  platforms: :ruby
# 上传头像
gem "paperclip", "~> 4.2"
# 异常通知邮件
gem 'exception_notification', '~> 4.0.1'
# UI
gem 'bootstrap-sass'
gem 'fastercsv', '~> 1.5.5'
gem 'spreadsheet'
# gem 'unicorn'
gem 'puma', '~> 3.8', '>= 3.8.2'
group :development do
  gem 'spring'
  gem 'capistrano', '~> 3.6'
  # cap tasks to manage puma application server
  gem 'capistrano-sidekiq', '~> 0.10.0'
  gem 'capistrano-puma', require: false
  gem 'capistrano-rails',   '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rvm',   '~> 0.1', require: false
end
group :development, :test do
  gem 'sqlite3', '~> 1.3', '>= 1.3.13'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end
group :test do

end
group :production do

end
gem "simple-navigation"
gem 'rest-client'

gem "delayed_job_active_record"
gem "daemons"

gem 'annotate'

gem 'sidekiq', '~> 5.0'

gem 'sinatra'

gem 'redis-namespace', '~> 1.5', '>= 1.5.3'

gem 'puma_worker_killer'