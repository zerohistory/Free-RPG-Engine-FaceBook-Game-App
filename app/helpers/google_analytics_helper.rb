module GoogleAnalyticsHelper
  def google_analytics(&block)
    return unless ga_enabled?
    
    additional_code = block_given? ? capture(&block) : ''
    
    code = %{
      <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '#{ Setting.s(:app_google_analytics_id) }']);
        #{additional_code}
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = 'http://www.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
      </script>
    }.html_safe
    
    block_given? ? concat(code) : code
  end
  
  def ga_enabled?
    !Setting.s(:app_google_analytics_id).blank?
  end

  def ga_track_event(category, action, label = nil, value = nil)
    return unless ga_enabled?
    
    value = value.to_i
    
    ga_command('_trackEvent', category, action, label, value > 0 ? value : nil)
  end
  
  VARIABLE_SCOPES = {
    :visitor  => 3,
    :session  => 2,
    :page     => 1
  }
  
  def ga_set_variable(index, name, value, scope = :page)
    ga_command('_setCustomVar', index, name, value, VARIABLE_SCOPES[scope])
  end
  
  def ga_command(*args)
    "_gaq.push(#{args.to_json});".html_safe
  end
end