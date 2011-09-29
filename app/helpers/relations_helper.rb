module RelationsHelper
  def invitation_short_url(character)
    if Setting.b(:invitation_direct_link)
      "%s/cil/%s" % [
        Facebooker2.callback_url,
        character.invitation_key
      ]
    else
      "http://apps.facebook.com/%s/cil/%s" % [
        Facebooker2.canvas_page_name,
        character.invitation_key
      ]
    end
  end
end
