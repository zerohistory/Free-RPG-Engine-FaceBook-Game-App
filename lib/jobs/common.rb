module Jobs
  module Common
    def app_path(*path)
      File.join(Facebooker.facebooker_config["callback_url"], *path)
    end

    def facebook_session
      @session ||= Facebooker::Session.create
    end
  end
end
