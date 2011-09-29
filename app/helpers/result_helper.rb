module ResultHelper
  class Builder
    attr_reader :template, :options, :type

    delegate :capture, :concat, :content_tag, :dom_ready, :to => :template

    def initialize(template, type, options = {})
      @template = template
      @type     = type
      @options  = options
    end

    def title(content = nil, &block)
      result = content_tag(:h2, content ? content.html_safe : capture(&block))

      block_given? ? concat(result) : result
    end

    def message(type = nil, content = nil, &block)
      @message = {
        :content  => content || capture(&block),
        :type     => type
      }
    end

    def notice(content = nil, &block)
      message(nil, content, &block)
    end

    def success(content = nil, &block)
      message(:success, content, &block)
    end

    def fail(content = nil, &block)
      message(:fail, content, &block)
    end

    def render(path, options = {})
      @template.render(path, options.merge(:builder => self))
    end

    def buttons(content = nil, &block)
      @buttons ||= ""
      @buttons << (content || capture(&block))
    end

    def on_ready(content = nil, &block)
      @on_ready ||= ""
      @on_ready << (content || capture(&block))
      @on_ready << ";"
    end

    def html(content = nil, &block)
      content ||= capture(self, &block)

      dom_ready(@on_ready)
      dom_ready("$(document).trigger('result.#{options[:inline] ? :available : :received}');")

      content_tag(:div, "#{buttons_html} #{message_html} #{content}".html_safe,
        :id     => "#{type}_result",
        :class  => "result_content clearfix"
      )
    end

    protected

    def buttons_html
      content_tag(:div, @buttons.html_safe, :class => :buttons) unless @buttons.blank?
    end

    def message_html
      content_tag(:p, @message[:content], :class => @message[:type]) if @message
    end
  end

  def result_for(*args, &block)
    options = args.extract_options!
    type, content = args

    content = Builder.new(self, type, options).html(content, &block)

    block_given? ? concat(content) : content
  end
end
