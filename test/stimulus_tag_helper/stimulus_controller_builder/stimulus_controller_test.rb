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
          t.tag.button(type: "submit", **c.action("search")),
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
          <button type="submit" data-action="search#search"></button>
          <div data-search-target="results"></div>
        </form>
      HTML
    end

    def test_search_stimulus_controller
      assert_equal(expected_search_stimulus_controller_output, search_stimulus_controller)
    end
  end
end
