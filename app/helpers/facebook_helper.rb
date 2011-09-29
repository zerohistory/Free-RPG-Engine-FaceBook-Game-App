module FacebookHelper
  def fb_app_name(options = {:linked => false})
    tag("fb:application-name", options)
  end

  def fb_fan_box(options = {})
    content_tag("fb:fan", "", {:profile_id => Facebooker2.app_id}.merge(options))
  end

  def fb_header(text, options = {})
    content_tag("fb:header", text, options.reverse_merge(:icon => false))
  end

  def fb_date(date, format, options = {})
    date = date.to_time unless date.is_a?(DateTime)

    tag("fb:date",
      options.merge(
        :t => date.to_i,
        :format => format
      )
    )
  end

  def fb_comments(xid, options = {})
    content_tag('fb:comments', '', options.merge(:xid => xid))
  end

  def fb_pronoun(user, options = {})
    content_tag('fb:pronoun', '', options.merge(:uid => user.facebook_id))
  end

  def fb_custom_req_choice(label, url)
    content_tag("fb:req-choice", fb_fa(:label, label), :url => url)
  end

  def fb_profile_url(user)
    "http://www.facebook.com/profile.php?id=#{user.facebook_id}"
  end

  def fb_app_page_url
    "http://www.facebook.com/apps/application.php?id=#{Facebooker2.app_id}"
  end

  def fb_app_requests_url
    "http://www.facebook.com/reqs.php#confirm_#{Facebooker2.app_id}_0"
  end

  def fb_i(*args, &block)
    options = args.extract_options!

    tag = content_tag("fb:intl", "#{args.shift} #{capture(&block) if block_given?}", options)

    block_given? ? concat(tag) : tag
  end

  def fb_it(name, *args, &block)
    fb_named_tag("intl-token", name, *args, &block)
  end

  def fb_fa(name, *args, &block)
    fb_named_tag("fbml-attribute", name, *args, &block)
  end

  def fb_tag(name, *args, &block)
    fb_named_tag("tag", name, *args, &block)
  end

  def fb_ta(name, *args, &block)
    fb_named_tag("tag-attribute", name, *args, &block)
  end

  def fb_js_string(name, content = nil, &block)
    if block_given?
      output_buffer << content_tag("fb:js-string", capture(&block), :var => name)
    else
      content_tag("fb:js-string", content, :var => name)
    end
  end

  def fb_chat_invite(message, condensed = false, *exclude_ids)
    content_tag("fb:chat-invite", "",
      :msg          => message,
      :condensed    => (condensed || nil),
      :exclude_ids  => (exclude_ids.any? ? exclude_ids.join(",") : nil)
    )
  end

  def fb_bookmark_button(options = {})
    content_tag("fb:bookmark", "", options)
  end
  
  def if_fb_connect_initialized(command = nil, &block)
    command = capture(&block) if block_given?
    
    result = "if(typeof(FB) != 'undefined'){ #{command}; }else{ alert('The page failed to initialize properly. Please reload it and try again.'); }"
    result = result.html_safe
    
    block_given? ? concat(result) : result
  end
  
  def fb_request_dialog(type, options = {})
    callback  = options.delete(:callback)
    request_params = options.delete(:params) || {}
        
    if_fb_connect_initialized(
      "
        FB.ui(%s, function(response){ 
          if(typeof(response) != 'undefined' && response != null){ 
            $('#ajax').load('%s', {ids: response.request_ids}, function(){ %s }) 
          } 
        }); 
        
        $(document).trigger('facebook.dialog');
      " % [
        options.deep_merge(:method => 'apprequests', :data => {:type => type}).to_json,
        app_requests_path(request_params.merge(:type => type)),
        callback
      ]
    ).gsub(/\n\s+/, ' ')
  end

  protected

  def fb_named_tag(tag, name, *args, &block)
    options = args.extract_options!
    options.merge!(:name => name)

    tag = content_tag("fb:#{tag}", block_given? ? capture(&block): args.shift, options)

    block_given? ? concat(tag) : tag
  end
end
