# frozen_string_literal: true

module StimulusTagHelper
  class StimulusAction
    STANDARD_PARSER =
      /^(?<void>(?<event>.+?)(?<void>@(?<target>window|document))?->)?(?<identifier>.+?)(?<void>#(?<method>[^:]+?))(?<void>:(?<options>.+))?$/
    NO_CONTROLLER_PARSER =
      /^(?<void>(?<event>.+?)?(?<void>@(?<target>window|document))?->)?(?<method>[^#:]+?)(?<void>:(?<options>.+))?$/
    PARTS = %i[identifier method event target options]

    # event is nil to let stimulus.js decide default event for the element
    def initialize(identifier:, method:, event: nil, target: nil, options: nil)
      PARTS.each do |part|
        instance_variable_set(:"@#{part}", binding.local_variable_get(part))
      end
    end

    def to_s
      "#{event_part.presence&.+("->")}#{handler_part}"
    end

    def ==(other)
      other.is_a?(StimulusAction) && other.to_s == to_s
    end

    private

    attr_reader(*PARTS) # define attr readers for each part

    def event_part
      "#{event}#{"@#{target}" if target}"
    end

    def handler_part
      "#{identifier}##{method}#{":#{options}" if options}"
    end

    class << self
      def parse(string, **defaults)
        to_parse = string.to_s
        parsed =
          to_parse.include?("#") ? STANDARD_PARSER.match(to_parse) : NO_CONTROLLER_PARSER.match(to_parse)
        raise(ArgumentError, "Can't parse stimulus action #{string.inspect}") unless parsed

        new(**defaults.merge(parsed.named_captures.except("void").transform_keys(&:to_sym)))
      end
    end
  end
end
