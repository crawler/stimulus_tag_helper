# frozen_string_literal: true

module StimulusTagHelper
  class StimulusControllerBuilder
    class << self
      delegate :properties, :aliases, :attribute_method_name_for, :property_method_name_for, to: StimulusTagHelper
    end

    attr_reader :identifier, :template, :tag, :tag_options

    # all the options are tag options of now
    def initialize(identifier:, template:, tag: nil, **tag_options)
      @identifier = identifier
      @template = template
      @tag = tag
      @tag_options = tag_options
    end

    properties.each do |name|
      attribute_method_name = attribute_method_name_for(name)
      property_method_name = property_method_name_for(name)
      alias_name = aliases[name]

      class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def #{name}(*args, **kwargs)                                                        # def values(*args, **kwargs)
          template.stimulus_#{attribute_method_name}(*args.unshift(identifier), **kwargs)   #   template.stimulus_values_attributes(*args.unshift(identifier), **kwargs)
        end                                                                                 # end

        alias_method :#{alias_name}, :#{name}                                               # alias_method :value, :values
        alias_method :#{attribute_method_name}, :#{name}                                    # alias_method :values_attributes, :values
        alias_method :#{alias_name}_attribute, :#{name}                                     # alias_method :value_attribute, :values

        def #{property_method_name}(*args, **kwargs)                                        # def values_properties(*args, **kwargs)
          template.stimulus_#{property_method_name}(*args.unshift(identifier), **kwargs)    #   template.stimulus_values_properties(*args.unshift(identifier), **kwargs)
        end                                                                                 # end

        alias_method :#{alias_name}_property, :#{property_method_name}                      # alias_method :value_property, :values_properties
      RUBY
    end

    def attributes(**attributes)
      template.stimulus_attributes(identifier, **attributes)
    end

    def properties(**properties)
      template.stimulus_properties(identifier, **properties)
    end

    def capture(&block)
      return template.capture(self, &block) unless tag

      template.stimulus_controller_tag(identifier, tag: tag, **tag_options) do
        template.capture(self, &block)
      end
    end
  end
end
