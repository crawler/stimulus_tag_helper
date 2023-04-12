# frozen_string_literal: true

require "test_helper"

module StimulusTagHelper
  class StimulusAction::ParseTest < Minitest::Test
    def subject
      StimulusAction.method(:parse)
    end

    def test_invalid_args
      assert_raises(ArgumentError) { subject.call(nil) }
      assert_raises(ArgumentError) { subject.call("") }
    end

    def test_reference_example1
      action = subject.call("click->gallery#next")

      assert_equal(
        StimulusAction.new(event: "click", identifier: "gallery", method: "next"),
        action
      )
      assert_equal("click->gallery#next", action.to_s)
    end

    def test_reference_event_shorthand
      action = subject.call("gallery#next")

      assert_equal(
        StimulusAction.new(identifier: "gallery", method: "next"),
        action
      )
      assert_equal("gallery#next", action.to_s)
    end

    def test_reference_global_events
      action = subject.call("resize@window->gallery#layout")

      assert_equal(
        StimulusAction.new(event: "resize", target: "window", identifier: "gallery", method: "layout"),
        action
      )
      assert_equal("resize@window->gallery#layout", action.to_s)
    end

    def test_reference_options1
      action = subject.call("scroll->gallery#layout:!passive")

      assert_equal(
        StimulusAction.new(event: "scroll", identifier: "gallery", method: "layout", options: "!passive"),
        action
      )
      assert_equal("scroll->gallery#layout:!passive", action.to_s)
    end

    def test_reference_options2
      action = subject.call("click->gallery#open:capture")

      assert_equal(
        StimulusAction.new(event: "click", identifier: "gallery", method: "open", options: "capture"),
        action
      )
      assert_equal("click->gallery#open:capture", action.to_s)
    end

    def test_parse_with_defaults
      action = subject.call("next", identifier: "gallery")

      assert_equal(
        StimulusAction.new(identifier: "gallery", method: "next"),
        action
      )
      assert_equal("gallery#next", action.to_s)
    end

    def test_defaults_can_be_overridden
      action = subject.call("form#next", identifier: "gallery")

      assert_equal(
        StimulusAction.new(identifier: "form", method: "next"),
        action
      )
      assert_equal("form#next", action.to_s)
    end
  end
end
