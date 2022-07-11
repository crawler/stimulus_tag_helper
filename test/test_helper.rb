# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "stimulus_tag_helper"
require "rails/version"
require "active_support/test_case"
require "action_view"
require "active_model"
require "minitest/autorun"

Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |rb| require(rb) }
