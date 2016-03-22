module GovukElementsFormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder

    include ActionView::Helpers::CaptureHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    def text_field(name,*arg)
      @template.content_tag :div, class: 'form-group' do
        options = arg.extract_options!

        label_class = ["form-label"]
        if options[:label].present?
          label_class << options[:label][:class] if options[:label][:class].present?
        end

        text_field_class = ["form-control"]
        if options[:class].present?
          text_field_class << options[:class] if options[:class].present?
        end
        options[:class] = text_field_class

        label(name, class: label_class) + super(name, options.except(:label))
      end
    end

    include ActionView::Helpers::TagHelper

    def error_summary object, heading, description
      return if object.errors.blank?
      error_summary_div do
        error_summary_heading(heading) +
        error_summary_description(description) +
        error_summary_messages
      end
    end

    private

    def error_summary_div &block
      @template.content_tag(:div,
          class: 'error-summary',
          role: 'group',
          aria: {
            labelledby: 'error-summary-heading'
          },
          tabindex: '-1') do
        yield block
      end
    end

    def error_summary_heading text
      @template.content_tag :h1,
        text,
        id: 'error-summary-heading',
        class: 'heading-medium error-summary-heading'
    end

    def error_summary_description text
      @template.content_tag :p, text
    end

    def error_summary_messages
      @template.content_tag(:ul,
          class: 'error-summary-list') do
        prefix = object.class.name.underscore

        object.errors.keys.map do |attribute|
          error_summary_message object, prefix, attribute
        end.flatten.join('').html_safe
      end
    end

    def error_summary_message object, prefix, attribute
      messages = object.errors.full_messages_for attribute
      messages.map do |message|
        @template.content_tag(:li, @template.content_tag(:a, message, href: "##{prefix}_#{attribute}_error"))
      end
    end
  end
end
