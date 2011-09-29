class CharacterStatus
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/character_status/
      request = Rack::Request.new(env)
      
      if fb_cookie = request.cookies["fbs_#{Facebooker2.app_id}"]
        facebook_session = {}.tap do |hash|
          data = fb_cookie.gsub(/"/,"")

          data.split("&").each do |str|
            parts = str.split("=")
            hash[parts.first] = parts.last
          end
        end

        if facebook_session['uid'] and character = User.find_by_facebook_id(facebook_session['uid']).try(:character)
          [200, {"Content-Type" => "application/json"}, character.to_json_for_overview]
        else
          [200, {"Content-Type" => "application/json"}, {}.to_json]
        end
      else
        [200, {"Content-Type" => "application/json"}, {}.to_json]
      end
    else
      [404, {"Content-Type" => "text/html"}, "Not Found"]
    end
  ensure
    ActiveRecord::Base.clear_active_connections!
  end
end
