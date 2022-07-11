# frozen_string_literal: true

require "test_helper"

class StimulusTagHelperTest < TestCase
  def test_that_it_has_a_version_number
    assert_not_nil ::StimulusTagHelper::VERSION
  end

  def singular_input
    {value: {url: "/slides"}, class: {loading: "slide--loading"}, target: "slide",
     action: "click->next"}
  end

  def expected_singular_properties
    {"gallery-url-value" => "/slides", "gallery-loading-class" => "slide--loading",
     "gallery-target" => "slide", :action => "click->gallery#next"}
  end

  def plural_input
    {values: {url: "/slides", method: "put"}, classes: {loading: "slide--loading", animating: "slide--animating"},
     targets: %w[slide active], actions: %w[next blur->prev]}
  end

  def expected_plural_properties
    expected_values_properties
      .merge(expected_classes_properties)
      .merge(expected_targets_properties)
      .merge(expected_actions_property)
  end

  def expected_values_properties
    {"gallery-url-value" => "/slides", "gallery-method-value" => "put"}
  end

  def expected_classes_properties
    {"gallery-loading-class" => "slide--loading", "gallery-animating-class" => "slide--animating"}
  end

  def expected_targets_properties
    {"gallery-target" => "slide active"}
  end

  def expected_actions_property
    {action: "gallery#next blur->gallery#prev"}
  end

  def test_values_properties
    assert_equal(expected_values_properties, t.stimulus_values_properties("gallery", **plural_input[:values]))
  end

  def test_classes_properties
    assert_equal(expected_classes_properties, t.stimulus_classes_properties("gallery", **plural_input[:classes]))
  end

  def test_targets_properties
    assert_equal(expected_targets_properties, t.stimulus_targets_properties("gallery", *plural_input[:targets]))
  end

  def test_actions_property
    assert_equal(expected_actions_property, t.stimulus_actions_property("gallery", *plural_input[:actions]))
  end

  def test_stimulus_properties
    assert_equal(expected_singular_properties, t.stimulus_properties("gallery", **singular_input))
    assert_equal(expected_plural_properties, t.stimulus_properties("gallery", **plural_input))
  end

  def test_stimulus_attributes
    assert_equal({data: expected_singular_properties}, t.stimulus_attributes("gallery", **singular_input))
    assert_equal({data: expected_plural_properties}, t.stimulus_attributes("gallery", **plural_input))
  end

  def test_stimulus_controller_tag
    assert_equal('<div data-controller="gallery"></div>', t.stimulus_controller_tag("gallery", tag: "div"))
  end
end
