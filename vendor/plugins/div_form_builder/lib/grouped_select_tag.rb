module GroupedSelectTag
  module InstanceTagExtension
    def to_grouped_select_tag(choices, options, html_options)
      html_options = html_options.stringify_keys
      add_default_name_and_id(html_options)
      value = value(object)
      selected_value = options.has_key?(:selected) ? options[:selected] : value
      disabled_value = options.has_key?(:disabled) ? options[:disabled] : nil
      content_tag("select", add_options(grouped_options_for_select(choices, :selected => selected_value, :disabled => disabled_value), options, selected_value), html_options)
    end
  end

  module ActionViewExtension
    def grouped_select(object, method, choices, options = {}, html_options = {})
      ActionView::Helpers::InstanceTag.new(object, method, self, options.delete(:object)).to_grouped_select_tag(choices, options, html_options)
    end
  end
end