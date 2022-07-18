# frozen_string_literal: true

require "test_helper"

class StimulusTagHelperTest < TestCase
  def test_that_it_has_a_version_number
    assert_not_nil ::StimulusTagHelper::VERSION
  end

  def singular_input
    {controller: "clipboard", value: {url: "/slides"}, class: {loading: "slide--loading"}, target: "slide",
     action: "click->next"}
  end

  def expected_singular_attributes
    {data: expected_singular_properties}
  end

  def expected_singular_properties
    expected_controller_poperty
      .merge(expected_value_property)
      .merge(expected_class_property)
      .merge(expected_target_property)
      .merge(expected_action_property)
  end

  def expected_controller_poperty
    {controller: "clipboard"}
  end

  def expected_value_property
    {"clipboard-url-value" => "/slides"}
  end

  def expected_class_property
    {"clipboard-loading-class" => "slide--loading"}
  end

  def expected_target_property
    {"clipboard-target" => "slide"}
  end

  def expected_action_property
    {action: "click->clipboard#next"}
  end

  def plural_input
    {controllers: %w[gallery clipboard], values: {url: "/slides", method: "put"},
     classes: {loading: "slide--loading", animating: "slide--animating"}, targets: %w[slide active],
     actions: %w[next blur->prev]}
  end

  def expected_plural_properties
    expected_controllers_property
      .merge(expected_values_properties)
      .merge(expected_classes_properties)
      .merge(expected_targets_properties)
      .merge(expected_actions_property)
  end

  def expected_controllers_property
    {controller: "gallery clipboard"}
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

  def test_stimulus_controllers_attribute
    assert_equal({data: expected_controller_poperty}, t.stimulus_controller_attribute(singular_input[:controller]))
    assert_equal({data: expected_controllers_property}, t.stimulus_controllers_attribute(*plural_input[:controllers]))
  end

  def test_stimulus_values_attributes
    assert_equal({data: expected_value_property}, t.stimulus_value_attribute("clipboard", **singular_input[:value]))
    assert_equal({data: expected_values_properties}, t.stimulus_values_attributes("gallery", **plural_input[:values]))
  end

  def test_stimulus_classes_attributes
    assert_equal({data: expected_class_property}, t.stimulus_class_attribute("clipboard", **singular_input[:class]))
    assert_equal({data: expected_classes_properties}, t.stimulus_classes_attributes("gallery", **plural_input[:classes]))
  end

  def test_stimulus_targets_properties
    assert_equal({data: expected_target_property}, t.stimulus_target_attribute("clipboard", singular_input[:target]))
    assert_equal({data: expected_targets_properties}, t.stimulus_targets_attributes("gallery", *plural_input[:targets]))
  end

  def test_stimulus_actions_attribute
    assert_equal({data: expected_action_property}, t.stimulus_action_attribute("clipboard", singular_input[:action]))
    assert_equal({data: expected_actions_property}, t.stimulus_actions_attribute("gallery", *plural_input[:actions]))
  end

  def test_stimulus_attributes
    assert_equal({data: expected_singular_properties}, t.stimulus_attributes("clipboard", **singular_input))
    assert_equal({data: expected_plural_properties}, t.stimulus_attributes("gallery", **plural_input))
  end

  def test_stimulus_properties
    assert_equal(expected_singular_properties, t.stimulus_properties("clipboard", **singular_input))
    assert_equal(expected_plural_properties, t.stimulus_properties("gallery", **plural_input))
  end

  def test_stimulus_controller_tag
    assert_equal(
      '<div data-controller="gallery" data-gallery-url-value="/slides"></div>',
      t.stimulus_controller_tag("gallery", tag: "div", values: {url: "/slides"})
    )
  end
end
