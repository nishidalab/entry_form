source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

#githubのminitest指定
gem 'minitest', '5.10.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.1'
# Use Puma as the app server
gem 'puma', '3.4.0'
# Use SCSS for stylesheets
gem 'sass-rails', '5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '3.0.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '4.2.1'
# Use jquery as the JavaScript library
gem 'jquery-rails', '4.1.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '5.0.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.5'
# Use ActiveModel has_secure_password
gem 'bcrypt', '3.1.11'
# Use SCSS for Bootstrap
gem 'bootstrap-sass', '3.3.6'
# I18n
gem 'i18n_generators'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '1.3.11'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '3.3.0'
end

group :test do
  # Use assert_template
  gem 'rails-controller-testing', '0.1.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# カレンダー表示
gem 'fullcalendar-rails', '3.1.0.0'
gem 'momentjs-rails', '2.17.1'

# 秘密情報を入れとくやつ
gem 'config', '1.4.0'

# Bootstrap
gem 'twitter-bootstrap-rails', '4.0.0'

# JQueryが上手く動かないことがあるので
gem 'jquery-turbolinks', '2.1.0'

# 確認モーダル
gem 'data-confirm-modal', '1.3.0'

# マウスオーバー
gem 'hint'
