# frozen_string_literal: true

require "test_helper"

module StimulusTagHelper
  class StimulusControllerBuilder::StimulusControllerWithoutTagTest < TestCase
    class Search
      include ActiveModel::Model

      attr_accessor :query

      def self.model_name
        ActiveModel::Name.new(self, nil, "Search")
      end
    end

    def stimulus_controller
      t.stimulus_controller("search") do |c|
        t.form_for(model, path: "/search", **c.attributes(classes: {working: "progress"}, values: {url: "/search"})) do |f|
          t.safe_join([
            f.text_field(
              :query,
              **c.attributes(
                target: "query", actions: ["focus->handleFocus", "complete", "blur->other-controller#searchLostFocus"]
              )
            ),
            f.submit(**c.action("search")),
            t.tag.div(**c.target("results"))
          ])
        end
      end
    end

    def model
      Search.new
    end

    def test_stimulus_controller_without_tag
      assert_equal(expected_output, stimulus_controller)
    end

    def expected_output
      case Rails.version[0..2]
      when "6.0"
        rails_6_0_output
      when "6.1"
        rails_6_1_output
      else
        rails_7_output
      end
    end

    def rails_7_output
      # %r{^(\s{2})+} matches only even number of spaces, to be able to leave space between attrs
      <<~HTML.split("\n").map { |str| str.sub(%r{^(\s{2})+}, "") }.join("")
        <form data-search-url-value="/search" data-search-working-class="progress" class="new_search" id="new_search"
           action="/search" accept-charset="UTF-8" method="post">
          <input name="utf8" type="hidden" value="&#x2713;" autocomplete="off" />
          <input data-search-target="query"
             data-action="focus->search#handleFocus search#complete blur->other-controller#searchLostFocus" type="text"
             name="search[query]" id="search_query" />
          <input type="submit" name="commit" value="Create Search"
             data-action="search#search" data-disable-with="Create Search" />
          <div data-search-target="results"></div>
        </form>
      HTML
    end

    def rails_6_1_output
      # %r{^(\s{2})+} matches only even number of spaces, to be able to leave space between attrs
      <<~HTML.split("\n").map { |str| str.sub(%r{^(\s{2})+}, "") }.join("")
        <form class="new_search" id="new_search" data-search-url-value="/search" data-search-working-class="progress"
           action="/search" accept-charset="UTF-8" method="post">
          <input name="utf8" type="hidden" value="&#x2713;" autocomplete="off" />
          <input data-search-target="query"
             data-action="focus->search#handleFocus search#complete blur->other-controller#searchLostFocus" type="text"
             name="search[query]" id="search_query" />
          <input type="submit" name="commit" value="Create Search"
             data-action="search#search" data-disable-with="Create Search" />
          <div data-search-target="results"></div>
        </form>
      HTML
    end

    def rails_6_0_output
      # %r{^(\s{2})+} matches only even number of spaces, to be able to leave space between attrs
      <<~HTML.split("\n").map { |str| str.sub(%r{^(\s{2})+}, "") }.join("")
        <form class="new_search" id="new_search" data-search-url-value="/search" data-search-working-class="progress"
           action="/search" accept-charset="UTF-8" method="post">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <input data-search-target="query"
             data-action="focus->search#handleFocus search#complete blur->other-controller#searchLostFocus" type="text"
             name="search[query]" id="search_query" />
          <input type="submit" name="commit" value="Create Search"
             data-action="search#search" data-disable-with="Create Search" />
          <div data-search-target="results"></div>
        </form>
      HTML
    end
  end
end
