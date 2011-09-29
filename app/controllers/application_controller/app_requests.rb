class ApplicationController
  module AppRequests
    protected
    
    def app_request_ids
      params[:request_ids].present? ? params[:request_ids].split(',').collect{|v| v.to_i } : []
    end
    
    def visit_from_app_request?
      !app_request_ids.empty?
    end
    
    def visit_from_bookmark_counter?
      params[:ref] == 'bookmarks' && params[:count].to_i > 0
    end
    
    def app_requests
      @app_requests_from_params ||= visit_from_app_request? ? AppRequest::Base.find_all_by_facebook_id(app_request_ids) : []
    end
    
    def redirect_by_app_request
      if visit_from_app_request?
        session[:return_to] = nil

        redirect_back app_requests_url(:canvas => true)
      end
    end

    def check_user_app_requests
      if visit_from_app_request? || visit_from_bookmark_counter?
        Delayed::Job.enqueue Jobs::UserRequestCheck.new(current_user.id)
      end
      
      redirect_by_app_request || yield
      
      app_requests.each do |r| 
        r.visit
      end
    end
  end
end