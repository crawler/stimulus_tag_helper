# frozen_string_literal: true

module StimulusTagHelper
  class StimulusAction
    STANDARD_PARSER =
      /^(?<void>(?<event>.+?)(?<void>@(?<target>window|document))?->)?(?<identifier>.+?)(?<void>#(?<method>[^:]+?))(?<void>:(?<options>.+))?$/.freeze
    NO_CONTROLLER_PARSER =
      /^(?<void>(?<event>.+?)?(?<void>@(?<target>window|document))?->)?(?<method>[^#:]+?)(?<void>:(?<options>.+))?$/.freeze
    class_attribute :parts, default: %i[identifier method event target options]
    attr_reader(*parts)

    # event is nil to let stimulusjs decide default event for the element
    def initialize(identifier:, method:, event: nil, target: nil, options: nil)
      parts.each do |part|
        instance_variable_set(:"@#{part}", binding.local_variable_get(part))
      end
    end

    def event_part
      "#{event}#{"@#{target}" if target}"
    end

    def handler_part
      "#{identifier}##{method}#{":#{options}" if options}"
    end

    def to_s
      "#{event_part.presence&.+'->'}#{handler_part}".html_safe
    end

    def self.parse(str)
      parsed =
        str.include?("#") ? STANDARD_PARSER.match(str) : NO_CONTROLLER_PARSER.match(str)
      raise(ArgumentError, "can't parse action string #{str}") unless parsed

      parsed.named_captures.except("void").symbolize_keys
    end
  end
end
