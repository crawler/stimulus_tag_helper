# frozen_string_literal: true

module StimulusTagHelper
  class StimulusControllerBuilder
    def initialize(identifier:, template:)
      @identifier = identifier
      @template = template
    end

    StimulusTagHelper.property_names.each do |name|
      name = name.to_s
      attribute, property = name.pluralize == name ? %w[attributes properties] : %w[attribute property]

      class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def #{name}_#{attribute}(...)         # def value_attribute(...)
          { data: #{name}_#{property}(...) }  #   { data: value_property(...) }
        end                                   # end

        alias #{name} #{name}_#{attribute} # alias value value_attribute

        def #{name}_#{property}(*args, **kwargs)                                        # def value_property(*args, **kwargs)
          @template.stimulus_#{name}_#{property}(*args.unshift(@identifier), **kwargs)  #   stimulus_value_property(@identifier, *args, **kwargs)
        end                                                                             # end
      RUBY
    end

    def attributes(**attributes)
      @template.stimulus_attributes(@identifier, **attributes)
    end
  end
end
