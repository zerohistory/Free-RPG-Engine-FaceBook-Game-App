class ApplicationController
  module FacebookIntegration
    def self.included(base)
      base.class_eval do
        include Facebooker2::Rails::Controller
        
        rescue_from Facebooker2::OAuthException, :with => :rescue_facebooker_oauth_exception
      end

      base.extend(ClassMethods)
    end

    module ClassMethods
      def facebook_integration_filters
        before_filter :ensure_canvas_connected_to_facebook
        before_filter :set_p3p_header
      end
    end

    def ensure_canvas_connected_to_facebook
      ensure_canvas_connected(:email)
    end

    def rescue_facebooker_oauth_exception(exception)
      if params[:error_reason] == 'user_denied' and HelpPage.visible?(:permissions)
        redirect_from_iframe help_page_url(:permissions, :canvas => true)
      else
        logger.fatal(exception)

        log_browser_info

        redirect_from_iframe root_url(:canvas => true)
      end
    end

    # Send P3P privacy header to enable iframe cookies in IE
    def set_p3p_header
      headers["P3P"] = 'CP="CAO PSA OUR"'
    end

  end
end