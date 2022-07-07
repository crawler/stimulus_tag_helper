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

        def #{name}_#{property}(*args, **kws)                                        # def value_property(*args, **kws)
          @template.stimulus_#{name}_#{property}(*args.unshift(@identifier), **kws)  #   stimulus_value_property(@identifier, *args, **kws)
        end                                                                          # end
      RUBY
    end

    def attributes(props)
      {data: @template.stimulus_properties(@identifier, props)}
    end
  end
end
