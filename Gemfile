# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "minitest"
gem "minitest-ci"
gem "minitest-reporters"
gem "rake"

group :lint do
  gem "reek", require: false
  gem "standard", "~> 1.12.1", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-minitest", require: false
  gem "slim_lint", require: false
  gem "parser", "3.1.2", require: false # match dev ruby version need
end

group :really_development do
  gem "overcommit", require: false
end
