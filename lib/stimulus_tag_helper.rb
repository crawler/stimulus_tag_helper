# frozen_string_literal: true

module StimulusTagHelper
  autoload :VERSION, "stimulus_tag_helper/version"
  autoload :StimulusAction, "stimulus_tag_helper/stimulus_action"
  autoload :StimulusControllerBuilder, "stimulus_tag_helper/stimulus_controller_builder"

  def self.base_properties
    %i[controller values classes targets target actions]
  end

  def self.aliases_map
    { values: :value, classes: :class, actions: :action }
  end

  def self.alias_properties
    @alias_properties ||= aliases_map.values
  end

  def self.property_names
    @property_names ||= base_properties + alias_properties
  end

  def self.prevent_duplicates(properties_set, name)
    alias_name = StimulusTagHelper.aliases_map[name]
    return unless alias_name && (properties_set[alias_name])

    raise(ArgumentError, <<~STRING)
      "#{name} and #{alias_name} can't be passed at same time"
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

  def stimulus_controller_tag(identifier, tag:, data: {}, **args, &block)
    data.merge!(stimulus_controllers_property(identifier))
    # class option goes to the tag
    data.merge!(stimulus_properties(identifier, args.extract!(*StimulusTagHelper.property_names - %i[class])))
    tag_builder.tag_string(tag, **args.merge(data: data), &block)
  end

  def stimulus_properties(identifier, props)
    {}.tap do |data|
      StimulusTagHelper.property_names.each do |name|
        next unless props[name]

        params = Array.wrap(props[name]).unshift(identifier)
        kwparams = params.last.is_a?(Hash) ? params.pop : {}
        StimulusTagHelper.prevent_duplicates(props, name)
        name = name.to_s
        property = name.pluralize == name ? "properties" : "property"
        data.merge!(public_send("stimulus_#{name}_#{property}", *params, **kwparams))
      end
    end
  end

  def stimulus_controllers_property(*identifiers)
    { controller: Array.wrap(identifiers).join(" ") }
  end

  alias stimulus_controller_property stimulus_controllers_property

  def stimulus_values_properties(identifier, **values)
    {}.tap do |properties|
      values.each_pair do |name, value|
        properties["#{identifier}-#{name}-value"] = value
      end
    end
  end

  alias stimulus_value_property stimulus_values_properties

  def stimulus_classes_properties(identifier, **classes)
    {}.tap do |properties|
      classes.each_pair do |name, value|
        properties["#{identifier}-#{name}-class"] = value
      end
    end
  end

  alias stimulus_class_property stimulus_classes_properties

  def stimulus_targets_properties(identifier, *targets)
    {}.tap do |properties|
      targets.each do |target|
        properties.merge!(stimulus_target_property(identifier, target))
      end
    end
  end

  def stimulus_target_property(identifier, name)
    { "#{identifier}-target" => name }
  end

  def stimulus_actions_properties(identifier, *actions_params)
    {
      "action" => actions_params.map { |action_params| stimulus_action_value(identifier, action_params) }.join(" ")
    }
  end

  alias stimulus_action_property stimulus_actions_properties

  def stimulus_action_value(identifier, action_params_or_action_str)
    if action_params_or_action_str.is_a?(String)
      action_params_or_action_str = StimulusAction.parse(action_params_or_action_str)
    end

    StimulusAction.new(identifier: identifier, **action_params_or_action_str).to_s
  end

  property_names.each do |name|
    name = name.to_s
    attribute, property = name.pluralize == name ? %w[attributes properties] : %w[attribute property]
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def stimulus_#{name}_#{attribute}(...)        # def stimulus_value_attribute(...)
        { data: stimulus_#{name}_#{property}(...) } #   { data: stimulus_value_property(...) }
      end                                           # end
    RUBY
  end

  def stimulus_attribute(...)
    { data: stimulus_properties(...) }
  end
end
