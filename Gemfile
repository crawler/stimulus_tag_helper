# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "minitest"
gem "minitest-ci"
gem "minitest-reporters"
gem "rake"
gem "nokogiri", ">= 1.13.7" # Somehow Gemfile.lock being updated with nokogiri 1.11.1 so i lock this here

group :lint do
  gem "reek", require: false
  gem "standard", ">= 1.14.0", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-minitest", require: false
  gem "slim_lint", require: false
  gem "parser", "3.1.2", require: false # match dev ruby version need
end

group :really_development do
  gem "overcommit", require: false
end
