class ShortLink
  extend ApplicationController::ReferenceCode
  
  def self.call(env)
    if match_data = env["PATH_INFO"].match(/^\/cil\/(\d+-[a-z0-9]+)/) and key = match_data[1]
      if user_id = user_id(key)
        target_url = "%s/relations/%s?reference_code=%s" % [
          Facebooker2.canvas_page_url,
          key,
          CGI.escape(reference_code(:invite_link, user_id))
        ]

        [200, {"Content-Type" => "text/html"}, iframe_redirect_code(target_url)]
      else
        [200, {"Content-Type" => "text/html"}, iframe_redirect_code(Facebooker2.canvas_page_url)]
      end
    else
      [404, {"Content-Type" => "text/html"}, "Not Found"]
    end
  rescue Exception => e
    #TODO Possibly this rescue is not necessary. Remove it if there will be no errors.
    Rails.logger.error "Failed to parse short link: '#{env["PATH_INFO"]}'"
    Rails.logger.error e

    [200, {"Content-Type" => "text/html"}, iframe_redirect_code(Facebooker2.canvas_page_url)]
  end

  def self.user_id(key)
    Character.find_by_invitation_key(key).try(:user_id)
  end

  def self.iframe_redirect_code(target_url)
    %{
      <html><head>
        <script type="text/javascript">
          window.top.location.href = #{target_url.to_json};
        </script>
        <noscript>
          <meta http-equiv="refresh" content="0;url=#{target_url}" />
          <meta http-equiv="window-target" content="_top" />
        </noscript>
      </head></html>
    }
  end
end
