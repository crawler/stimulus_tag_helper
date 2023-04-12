# frozen_string_literal: true

require "active_support/all"
require "zeitwerk"
Zeitwerk::Loader.for_gem.setup

module StimulusTagHelper
  def self.properties
    %i[controllers values classes targets actions outlets].freeze
  end

  def self.aliases
    @aliases ||= {}.tap do |aliases|
      properties.each do |property|
        property_alias = property.to_s.singularize.to_sym
        aliases[property] = property_alias
        aliases[property_alias] = property
      end
    end.freeze
  end

  def self.all_possible_properties_names
    @all_possible_properties_names ||= aliases.keys
  end

  def self.property_method_name_for(property)
    property = aliases[property] if properties.exclude?(property)
    "#{property}_#{rendered_as(property) == :one ? "property" : "properties"}"
  end

  def self.attribute_method_name_for(property)
    property = aliases[property] if properties.exclude?(property)
    "#{property}_#{rendered_as(property) == :one ? "attribute" : "attributes"}"
  end

  def self.rendered_as(property)
    {controllers: :one, values: :many, classes: :many, targets: :many, actions: :one, outlets: :many} \
      [property] || raise(ArgumentError, "Unknown property: #{property.inspect}")
  end

  def self.prevent_duplicates(properties_set, name)
    alias_name = StimulusTagHelper.aliases[name]
    return unless alias_name && (properties_set[alias_name])

    raise(ArgumentError, <<~STRING)
      "#{name} and #{alias_name} should not be passed at the same time"
    STRING
  end

  def stimulus_controller(identifier, tag: nil, **options, &block)
    builder = StimulusControllerBuilder.new(identifier: identifier, tag: tag, template: self, **options)
    return builder unless block
    builder.capture(&block)
  end

  # controller arg is used to add additional stimulus controllers to the element
  def stimulus_controller_tag(identifier, tag:, data: {}, controller: nil, **args, &block)
    # class class interpreted as class attribute, not a stimulus class
    # what about value and action action? maybe here should be warning

    # maybe data should be merged in args?
    data.merge!(stimulus_properties(
      identifier,
      controller: data[:controller] || controller, # nil is allowed, because the args will be prepended by the identifier
      **args.extract!(*StimulusTagHelper.all_possible_properties_names - %i[class])
    ))
    tag_builder.tag_string(tag, **args.merge(data: data), &block)
  end

  def stimulus_attributes(...)
    {data: stimulus_properties(...)}
  end

  alias_method :stimulus_attribute, :stimulus_attributes

  def stimulus_properties(identifier, **props)
    props = props.symbolize_keys
    {}.tap do |data|
      StimulusTagHelper.all_possible_properties_names.each do |name|
        next unless props.key?(name)

        args = Array.wrap(props[name]).unshift(identifier)
        kwargs = args.last.is_a?(Hash) ? args.pop : {}
        StimulusTagHelper.prevent_duplicates(props, name)
        data.merge!(
          public_send("stimulus_#{StimulusTagHelper.property_method_name_for(name)}", *args, **kwargs)
        )
      end
    end
  end

  def stimulus_controllers_attribute(...)
    {data: stimulus_controllers_property(...)}
  end

  alias_method :stimulus_controller_attribute, :stimulus_controllers_attribute

  def stimulus_controllers_property(*identifiers)
    {controller: identifiers.flatten.compact.uniq.join(" ")}
  end

  alias_method :stimulus_controller_property, :stimulus_controllers_property

  def stimulus_values_attributes(...)
    {data: stimulus_values_properties(...)}
  end

  alias_method :stimulus_value_attribute, :stimulus_values_attributes

  def stimulus_values_properties(identifier, **values)
    {}.tap do |properties|
      values.each_pair do |name, value|
        properties["#{identifier}-#{name}-value"] = value
      end
    end
  end

  alias_method :stimulus_value_property, :stimulus_values_properties

  def stimulus_classes_attributes(...)
    {data: stimulus_classes_properties(...)}
  end

  alias_method :stimulus_class_attribute, :stimulus_classes_attributes

  def stimulus_classes_properties(identifier, **classes)
    {}.tap do |properties|
      classes.each_pair do |name, value|
        properties["#{identifier}-#{name}-class"] = value
      end
    end
  end

  alias_method :stimulus_class_property, :stimulus_classes_properties

  def stimulus_targets_attributes(...)
    {data: stimulus_targets_properties(...)}
  end

  alias_method :stimulus_target_attribute, :stimulus_targets_attributes

  def stimulus_targets_properties(identifier, *targets)
    {"#{identifier}-target" => targets.join(" ")}
  end

  alias_method :stimulus_target_property, :stimulus_targets_properties

  def stimulus_actions_property(identifier, *actions_params)
    {
      action: actions_params.flatten.map { |action_params| stimulus_action_value(identifier, action_params) }.join(" ").html_safe
    }
  end

  alias_method :stimulus_action_property, :stimulus_actions_property

  def stimulus_actions_attribute(...)
    {data: stimulus_actions_property(...)}
  end

  alias_method :stimulus_action_attribute, :stimulus_actions_attribute

  def stimulus_action_value(identifier, args_or_string) # :nodoc:
    return StimulusAction.parse(args_or_string, identifier: identifier) if args_or_string.is_a?(String)

    # WARNING: this is unsafe for public use by unexpired developers.
    # TODO: find a elegant way to escape -> splitter escaping &gt; back and forth.
    StimulusAction.new(identifier: identifier, **args_or_string).to_s.html_safe
  end

  def stimulus_outlets_attributes(...)
    {data: stimulus_outlets_properties(...)}
  end

  alias_method :stimulus_outlet_attribute, :stimulus_outlets_attributes

  def stimulus_outlets_properties(identifier, **outlets)
    {}.tap do |properties|
      outlets.each_pair do |name, selector|
        properties["#{identifier}-#{name}-outlet"] = selector
      end
    end
  end

  alias_method :stimulus_outlet_property, :stimulus_outlets_properties
end
