# frozen_string_literal: true

require "active_support/all"
require "zeitwerk"
Zeitwerk::Loader.for_gem.setup

module StimulusTagHelper
  def self.base_properties
    %i[controller values classes targets target actions].freeze
  end

  def self.aliases
    {controller: :controllers, value: :values, class: :classes, target: :targets, action: :actions}.freeze
  end

  def self.methods_map
    {controllers: :stimulus_controllers_property, values: :stimulus_values_properties,
     classes: :stimulus_classes_properties, targets: :stimulus_targets_properties, actions: :stimulus_actions_property}.freeze
  end

  def self.alias_properties
    @alias_properties ||= aliases.keys
  end

  def self.property_names
    @property_names ||= base_properties + alias_properties
  end

  def self.prevent_duplicates(properties_set, name)
    alias_name = StimulusTagHelper.aliases[name]
    return unless alias_name && (properties_set[alias_name])

    raise(ArgumentError, <<~STRING)
      "#{name} and #{alias_name} should not be passed at the same time"
    STRING
  end

  def stimulus_controller(identifier, tag: nil, **args, &block)
    raise(ArgumentError, "Missing block") unless block

    builder = StimulusControllerBuilder.new(identifier: identifier, template: self)

    return capture(builder, &block) unless tag

    stimulus_controller_tag(identifier, tag: tag, **args) do
      capture(builder, &block)
    end
  end

  # controller arg is used to add additional stimulus controllers to the element
  def stimulus_controller_tag(identifier, tag:, data: {}, controller: nil, **args, &block)
    # class class interpreted as class attribute, not a stimulus class
    # what about value and action action? maybe here should be warning

    # maybe data should be merged in args?
    data.merge!(stimulus_properties(
      identifier,
      controller: data[:controller] || controller, # nil is allowed, because the args will be prepended by the identifier
      **args.extract!(*StimulusTagHelper.property_names - %i[class])
    ))
    tag_builder.tag_string(tag, **args.merge(data: data), &block)
  end

  # Does not includes the controller attribute
  def stimulus_attributes(...)
    {data: stimulus_properties(...)}
  end

  alias_method :stimulus_attribute, :stimulus_attributes

  # Does not includes the controller property
  def stimulus_properties(identifier, **props)
    {}.tap do |data|
      StimulusTagHelper.property_names.each do |name|
        next unless props.key?(name)

        args = Array.wrap(props[name]).unshift(identifier)
        kwargs = args.last.is_a?(Hash) ? args.pop : {}
        StimulusTagHelper.prevent_duplicates(props, name)
        data.merge!(
          public_send(StimulusTagHelper.methods_map[StimulusTagHelper.aliases[name] || name], *args, **kwargs)
        )
      end
    end
  end

  def stimulus_controllers_attribute(...)
    {data: stimulus_controllers_properties(...)}
  end

  alias_method :stimulus_controller_attribute, :stimulus_controllers_attribute

  def stimulus_controllers_property(*identifiers)
    {controller: Array.wrap(identifiers).compact.join(" ")}
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
      action: actions_params.map { |action_params| stimulus_action_value(identifier, action_params) }.join(" ").html_safe
    }
  end

  alias_method :stimulus_action_property, :stimulus_actions_property

  def stimulus_action_value(identifier, args_or_string) # :nodoc:
    return StimulusAction.parse(args_or_string, identifier: identifier) if args_or_string.is_a?(String)

    # WARNING: this is unsafe for public use by unexpired developers.
    # TODO: find a elegant way to escape -> splitter escaping &gt; back and forth.
    StimulusAction.new(identifier: identifier, **args_or_string).to_s.html_safe
  end
end
