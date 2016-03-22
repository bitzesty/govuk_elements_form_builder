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

    def error_summary object
      if object.errors.any?
        @template.content_tag(:div, class: :errors) do
          @template.content_tag(:ul) do
            object.errors.full_messages.map do |message|
              @template.content_tag(:li, message)
            end.join('').html_safe
          end
        end
      end
    end
  end
end
