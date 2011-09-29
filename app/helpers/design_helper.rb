module DesignHelper
  def hide_block_link(id)
    link_to_remote(t("blocks.hide").html_safe,
      :url    => toggle_block_user_path(current_user, :block => id),
      :before => "$('##{id}').hide()",
      :html   => {:class => :hide}
    )
  end

  def title(text, tag = :h1)
    content_tag(tag, text.html_safe, :class => :title)
  end

  def button(key, options = {})
    label = key.is_a?(Symbol) ? t(".buttons.#{key}", options) : key

    result = content_tag(:span, "", :class => "side")
    result << content_tag(:span, "", :class => "icon")
    result << label

    result.html_safe
  end

  def percentage_bar(percentage, options = {})
    options[:show_percentage] = true if options[:show_percentage].nil?

    result = ""
    result << options[:label].html_safe if options[:label]
    result << content_tag(:div, :class => "percentage_bar") do
      content_tag(:span, "", :class => "lc") <<
      content_tag(:div, :class => "complete", :style => "width: %.4f%" % percentage) do
        content_tag(:span, "", :class => "rc")
      end
    end

    result.html_safe
  end
end
