# frozen_string_literal: true

require "test_helper"

module StimulusTagHelper
  class StimulusControllerBuilder::StimulusControllerTest < TestCase
    def search_stimulus_controller
      t.stimulus_controller("search", tag: "form", classes: {working: "progress"}, values: {url: "/search"}) do |c|
        t.safe_join([
          t.tag.input(
            type: "text", placeholder: "Search...",
            **c.attributes(
              target: "query", actions: ["focus->handleFocus", "complete", "blur->other-controller#searchLostFocus"]
            )
          ),
          t.tag.button(type: "submit", **c.action("search")) { t.tag.span(data: c.properties(target: "spinner")) },
          t.tag.div(**c.target("results"))
        ])
      end
    end

    def expected_search_stimulus_controller_output
      # %r{^(\s{2})+} matches only even number of spaces, to be able to leave space between attrs
      <<~HTML.split("\n").map { |str| str.sub(%r{^(\s{2})+}, "") }.join("")
        <form data-controller="search" data-search-url-value="/search" data-search-working-class="progress">
          <input type="text" placeholder="Search..." data-search-target="query"
             data-action="focus->search#handleFocus search#complete blur->other-controller#searchLostFocus">
          <button type="submit" data-action="search#search">
            <span data-search-target="spinner"></span>
          </button>
          <div data-search-target="results"></div>
        </form>
      HTML
    end

    def test_search_stimulus_controller
      assert_equal(expected_search_stimulus_controller_output, search_stimulus_controller)
    end

    def any_possible_naming_controller
      t.stimulus_controller(
        "onomatet", tag: "div", targets: "me", classes: {working: "choosing-names"}, values: {this: "that"},
        actions: "load@document->work"
      ) do |c|
        t.safe_join([
          t.tag.div(
            **c.attributes(target: "thing", action: "unknown", value: {thought: "everything valuable"})
          ) { "Thing" },
          t.tag.div(
            **c.attributes(targets: "thing", actions: "unknown", values: {thought: "everything valuable"})
          ) { "Thing" },
          t.tag.div(
            **c.target("you")
              .deep_merge(
                c.action("click->askYourName").deep_merge(c.class(status: "unnamed").deep_merge(c.value(name: nil)))
              )
          ) { "You" },
          t.tag.div(
            **c.targets("you")
              .deep_merge(
                c.actions("click->askYourName").deep_merge(c.classes(status: "unnamed").deep_merge(c.values(name: nil)))
              )
          ) { "You" },
          t.tag.div(
            data: c.target_property("someone").merge(
              c.action_property("doSomething").merge(c.value_property(thought: "i`m bored"))
            )
          ) { "Who" },
          t.tag.div(
            data: c.targets_properties("someone").merge(
              c.actions_property("doSomething").merge(c.values_properties(thought: "i`m bored"))
            )
          ) { "Who" }
        ])
      end
    end

    def expected_any_possible_naming_controller_output
      # %r{^(\s{2})+} matches only even number of spaces, to be able to leave space between attrs
      <<~HTML.split("\n").map { |str| str.sub(%r{^(\s{2})+}, "") }.join("")
        <div data-controller="onomatet" data-onomatet-this-value="that" data-onomatet-working-class="choosing-names"
           data-onomatet-target="me" data-action="load@document->onomatet#work">
        <div data-onomatet-thought-value="everything valuable" data-onomatet-target="thing"
           data-action="onomatet#unknown">Thing</div>
        <div data-onomatet-thought-value="everything valuable" data-onomatet-target="thing"
           data-action="onomatet#unknown">Thing</div>
        <div data-onomatet-target="you" data-action="click->onomatet#askYourName"
           data-onomatet-status-class="unnamed">You</div>
        <div data-onomatet-target="you" data-action="click->onomatet#askYourName"
           data-onomatet-status-class="unnamed">You</div>
        <div data-onomatet-target="someone" data-action="onomatet#doSomething"
           data-onomatet-thought-value="i`m bored">Who</div>
        <div data-onomatet-target="someone" data-action="onomatet#doSomething"
           data-onomatet-thought-value="i`m bored">Who</div>
        </div>
      HTML
    end

    def test_any_possible_naming
      assert_equal(expected_any_possible_naming_controller_output, any_possible_naming_controller)
    end
  end
end
