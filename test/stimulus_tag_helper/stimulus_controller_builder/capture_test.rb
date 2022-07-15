# frozen_string_literal: true

require "test_helper"

module StimulusTagHelper
  # class StimulusControllerBuilder#capture method test
  class StimulusControllerBuilder::CaptureTest < TestCase
    # StimulusControllerBuilder instances is being accessed otside the scope of the block, and rendered with the
    # capture method.
    class ClipboardComponent
      include AlmostTemplate

      def call
        effects_controller.capture do
          clipboard_controller.capture do |cc|
            t.safe_join([
              "PIN: ",
              input,
              t.tag.button(**cc.action("copy")) { "Copy to Clipboard" }
            ])
          end
        end
      end

      private

      def effects_controller
        @effects_controller ||= t.stimulus_controller(:effects)
      end

      def clipboard_controller
        @clipboard_controller ||=
          t.stimulus_controller(
            :clipboard, tag: :div,
            **effects_controller.controller_property.merge(effects_controller.action_property("clipboard:copy->flash"))
          )
      end

      def input
        t.tag.input(**clipboard_controller.attributes(target: "source"), type: "text", value: "1234", readonly: true)
      end
    end

    def component
      ClipboardComponent.new
    end

    def expected_output
      # %r{^(\s{2})+} matches only even number of spaces, to be able to leave space between attrs
      <<~HTML.split("\n").map { |str| str.sub(%r{^(\s{2})+}, "") }.join("")
        <div data-controller="clipboard effects" data-action="clipboard:copy->effects#flash">
          PIN: <input data-clipboard-target="source" type="text" value="1234" readonly="readonly">
          <button data-action="clipboard#copy">Copy to Clipboard</button>
        </div>
      HTML
    end

    def test_capture
      assert_equal(expected_output, component.call)
    end
  end
end
