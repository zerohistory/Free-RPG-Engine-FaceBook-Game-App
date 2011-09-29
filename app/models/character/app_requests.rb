class Character
  module AppRequests
    def app_requests
      @app_requests ||= AppRequest::Base.for(self)
    end
  end
end