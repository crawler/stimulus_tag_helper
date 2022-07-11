# frozen_string_literal: true

require "test_helper"

module StimulusTagHelper
  class StimulusControllerBuilder::NestingTest < TestCase
    def list(id:, items:, children: [])
      t.stimulus_controller(:list, tag: :ul, id: id) do |c|
        t.safe_join([
          t.safe_join(items.map { |item| t.tag.li(**c.target(:item)) { item } }),
          children.any? ? t.tag.li(list(id: "child", items: children)) : nil
        ])
      end
    end

    def expected_list_output
      # %r{^(\s{2})+} matches only even number of spaces, to be able to leave space between attrs
      <<~HTML.split("\n").map { |str| str.sub(%r{^(\s{2})+}, "") }.join("")
        <ul id="parent" data-controller="list">
          <li data-list-target="item">One</li>
          <li data-list-target="item">Two</li>
          <li>
            <ul id="child" data-controller="list">
              <li data-list-target="item">I am</li>
              <li data-list-target="item">a nested list</li>
            </ul>
          </li>
        </ul>
      HTML
    end

    def test_list
      assert_equal(expected_list_output, list(id: "parent", items: ["One", "Two"], children: ["I am", "a nested list"]))
    end

    def clipboard
      t.stimulus_controller(:effects) do |ec|
        t.stimulus_controller(:clipboard, tag: :div, **ec.controller_property.merge(ec.action_property("clipboard:copy->flash"))) do |cc|
          t.safe_join([
            "PIN: ",
            t.tag.input(
              **cc.attributes(target: "source"),
              type: "text", value: "1234", readonly: true
            ),
            t.tag.button(**cc.action("copy")) { "Copy to Clipboard" }
          ])
        end
      end
    end

    def expected_clipboard_output
      # %r{^(\s{2})+} matches only even number of spaces, to be able to leave space between attrs
      <<~HTML.split("\n").map { |str| str.sub(%r{^(\s{2})+}, "") }.join("")
        <div data-controller="clipboard effects" data-action="clipboard:copy->effects#flash">
          PIN: <input data-clipboard-target="source" type="text" value="1234" readonly="readonly">
          <button data-action="clipboard#copy">Copy to Clipboard</button>
        </div>
      HTML
    end

    def test_clipboard
      assert_equal(expected_clipboard_output, clipboard)
    end
  end
end
