module DialogHelper
  class Builder
    def initialize(template, options = {})
      @template = template
      @options = options
    end

    def on_ready(&block)
      @on_ready = @template.capture(&block)
    end

    def html(&block)
      content = @template.capture(self, &block)

      content << @template.content_tag(:script, @on_ready, :type => "text/javascript") if @on_ready

      if @options.any?
        content = @template.content_tag(:div, content, @options)
      end

      content.html_safe
    end
  end

  def dialog(options = {}, &block)
    content = Builder.new(self, options).html(&block)

    dom_ready("$(document).queue('dialog', function(){ $.dialog('#{escape_javascript(content)}') });")
  end
end
