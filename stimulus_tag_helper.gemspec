# frozen_string_literal: true

require_relative "lib/stimulus_tag_helper/version"

Gem::Specification.new do |spec|
  spec.name = "stimulus_tag_helper"
  spec.version = StimulusTagHelper::VERSION
  spec.authors = ["Anton Topchii"]
  spec.email = ["player1@infinitevoid.net"]

  spec.summary = "A form_for like, compact and elegant way to define stimulus attributes in your views."
  spec.homepage = "https://github.com/crawler/stimulus_tag_helper"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/crawler/stimulus_tag_helper/issues",
    "changelog_uri" => "https://github.com/crawler/stimulus_tag_helper/releases",
    "source_code_uri" => "https://github.com/crawler/stimulus_tag_helper",
    "homepage_uri" => spec.homepage
  }

  spec.files = Dir.glob(%w[LICENSE.txt README.md lib/**/*]).reject { |f| File.directory?(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.0.0"
  # already there, but i feel uncomfortable to require in without specifing it here
  spec.add_dependency "activesupport", ">= 6.0.0"
  spec.add_dependency "zeitwerk", ">= 2.5.0"
end
