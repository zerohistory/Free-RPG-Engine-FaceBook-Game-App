# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionLogging
  include FacebookIntegration
  include ReferenceCode
  include AppRequests

  before_filter :check_character_existance, :except => [:facebook_oauth_connect]
  before_filter :check_character_health
  facebook_integration_filters
  
  layout :get_layout

  helper_method :current_user, :current_character, :current_skin

  helper :all

  protected

  def check_character_health
    if current_character
      if current_character.alive?
        return true
      else
        redirect_to premium_path
        return false
      end
    else
      return true
    end
  end

  def check_character_existance
    unless current_character
      store_return_to

      url_params = params.to_hash.symbolize_keys
      url_params.merge!(
        :controller => "/characters",
        :action     => :new,
        :id         => nil,
        :canvas     => true
      )

      redirect_from_iframe url_for(url_params)
    end
  end

  def current_character(force_reload = false)
    if current_user.nil?
      @current_character = nil
    elsif force_reload || @current_character.nil?
      @current_character = current_user.character(force_reload)
    end

    @current_character
  end

  def current_user
    if current_facebook_user
      @current_user ||= find_or_create_current_user
    end
  end

  def find_or_create_current_user
    facebook_id = current_facebook_user.id

    unless user = User.find_by_facebook_id(facebook_id)
      user = User.new
      
      user.facebook_id  = facebook_id
      user.signup_ip    = request.remote_ip

      if reference_data
        user.reference    = reference_data[0]
        user.referrer_id  = reference_data[1]
      elsif app_request = app_requests.last
        user.reference  = app_request.type_name
        user.referrer   = app_request.sender.try(:user)
      elsif params[:reference]
        user.reference = params[:reference]
      end
    end

    # Updating user access information
    user.access_token = current_facebook_user.client.access_token
    user.access_token_expire_at = current_facebook_user.client.expiration
    
    user.last_visit_at = Time.now if user.last_visit_at.nil? || user.last_visit_at < 30.minutes.ago
    user.last_visit_ip = request.remote_ip
    
    user.save!

    user
  end

  def default_url_options(options = {})
    options[:try_skin] = params[:try_skin] unless params[:try_skin].blank?
    options
  end

  def get_layout
    (current_character.nil? || current_character.new_record?) ? "unauthorized" : "application"
  end

  def current_skin
    params[:try_skin] ? Skin.find_by_id(params[:try_skin]) : Skin.with_state(:active).first
  end

  def store_return_to(uri = nil)
    session[:return_to] = uri
    session[:return_to] ||= params[:return_to]
    session[:return_to] ||= url_for(params_without_facebook_data.merge(:canvas => true)) unless controller_name == 'characters' && action_name == 'index'
  end

  def redirect_back(uri)
    if session[:return_to].present?
      uri = session[:return_to]

      session[:return_to] = nil
    end
    
    redirect_from_iframe(uri)
  end
end
