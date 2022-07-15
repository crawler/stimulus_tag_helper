# frozen_string_literal: true

module AlmostTemplate
  def template
    @template ||= Class.new do
      include ActionView::Rendering
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::FormHelper
      include StimulusTagHelper

      def polymorphic_path(...)
        "/search"
      end

      def output_buffer
        @output_buffer ||= ActionView::OutputBuffer.new
      end

      attr_writer :output_buffer
    end.new
  end

  alias_method :t, :template
end
