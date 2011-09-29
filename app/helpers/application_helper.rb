# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def include_jquery_from_google(version = "1.4.4")
    javascript_include_tag("http://ajax.googleapis.com/ajax/libs/jquery/#{version}/jquery.min.js") +
    javascript_tag("if(typeof jQuery == 'undefined'){document.write(unescape(\"%3Cscript src='#{javascript_path("jquery")}' type='text/javascript'%3E%3C/script%3E\"))}")
  end

  def admin_only(&block)
    if current_user && current_user.admin?
      concat(capture(&block))
    end
  end

  def group_header(text, group_name = :main, &block)
    @group_headers ||= {}

    if @group_headers[group_name] != text
      @group_headers[group_name] = text

      block_given? ? yield(text) : text
    end
  end

  def reset_group_header(group_name)
    @group_headers[group_name] = nil
  end

  def collection(*args, &block)
    options = args.extract_options!

    items = args.shift
    has_elements = args.shift || items.any?

    if has_elements
      yield(items)
    elsif options[:empty_set] != false
      concat(
        empty_set(options[:empty_set])
      )
    end
  end

  def empty_set(*args)
    options = args.extract_options!
    label = args.first

    content_tag(:div, label || t(".empty_set", :default => t("common.empty_set")), options.reverse_merge(:class => :empty_set))
  end

  def amount_select_tag(*args)
    options = args.extract_options!

    values = (1..10).to_a + args
    values.uniq!
    values.sort!

    select_tag(:amount, options_for_select(values, options[:selected]), options.except(:selected))
  end

  def dom_ready(content = nil, &block)
    @dom_ready ||= []

    if content
      @dom_ready << content
      nil
    elsif block_given?
      @dom_ready << capture(&block)
      nil
    else
      javascript_tag("$(function(){ #{ @dom_ready.join("\n") } });")
    end
  end

  def skin_path
    path = current_skin ? "skins/#{current_skin.name.parameterize}" : "application"

    stylesheet_path(path)
  end

  def flash_block(*args, &block)
    display_keys = args.any? ? args : [:success, :error, :notice]

    result = ""

    display_keys.each do |key|
      unless flash[key].blank?
        result << (block_given? ? capture(key, flash[key], &block) : content_tag(:p, flash[key], :class => key))
      end
    end

    unless result.blank?
      content_for(:result,
        result_for(flash[:class] || :flash, result.html_safe)
      )
    end
  end

  def maintenance_warning
    settings_path = Rails.root.join("public", "system", "maintenance.yml")

    if File.file?(settings_path)
      settings = YAML.load(File.read(settings_path))

      yield(settings) if settings[:start] > Time.now
    end
  end
end
