module Admin::BaseHelper
  def admin_flash_block(*args, &block)
    options = args.extract_options!
    display_keys = args.any? ? args : [:success, :error, :notice]

    result = ""

    display_keys.each do |key|
      unless flash[key].blank?
        value = block_given? ? capture(flash[key], &block) : flash[key]

        flash.discard(key)

        result << content_tag(:div, value,
          options.reverse_merge(:id => :flash, :class => key)
        )
      end
    end

    block_given? ? concat(result.html_safe) : result.html_safe
  end

  def admin_state(object)
    content_tag(:span, object.state.to_s.titleize, :class => object.state)
  end

  def admin_title(value, doc_topic = nil)
    @admin_title = value

    label = [
      value,
      (admin_documentation_link(doc_topic) unless doc_topic.blank?)
    ].compact.join(" ").html_safe

    content_tag(:h1, label, :class => :title)
  end

  def admin_documentation_link(topic)
    link_to(t("admin.documentation"), admin_documentation_url(topic),
      :target => :_blank,
      :class  => :documentation
    )
  end

  def admin_documentation_url(topic)
    "http://railorz.com/help/#{topic}"
  end

end