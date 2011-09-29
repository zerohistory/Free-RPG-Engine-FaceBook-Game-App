class RedirectFromIframeTo
  def initialize(expected)
    @expected = expected
  end

  def matches?(controller)
    if controller.body =~ /window.top.location.href = #{ Regexp.escape(@expected.to_json) };/
      true
    else
      @actual = controller.body.match(/window.top.location.href = "(.*)";/)[1]
      false
    end
  end

  def failure_message
    ["expected iframe redirect to '#{@expected.inspect}'", @actual ? "redirected to '#{@actual}' instead" : 'got no redirect'].join(', ')
  end
   
  def negative_failure_message
    ["expected no iframe redirect to '#{@expected.inspect}'", @actual ? "got redirect to '#{@actual}'" : nil].compact.join(', ')
  end
end

class RedirectFromIframe
  def matches?(controller)
    match = controller.body.match(/window.top.location.href = "(.+)";/im)

    if match and @actual = match[1]
      true
    else
      false
    end
  end

  def failure_message
    "expected iframe redirect, got no redirect"
  end
   
  def negative_failure_message
    "expected no iframe redirect, got redirect to '#{@actual}'"
  end
end

def redirect_from_iframe_to(expected)
  RedirectFromIframeTo.new(expected)
end

def redirect_from_iframe
  RedirectFromIframe.new
end
