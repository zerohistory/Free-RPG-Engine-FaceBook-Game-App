class AppRequestsController < ApplicationController
  skip_before_filter :check_character_existance, :ensure_canvas_connected_to_facebook, :only => :create
  
  def index
    @app_requests = current_character.app_requests.with_state(:processed, :visited).all(:order => "sender_id, created_at DESC")
  end
  
  def create
    @request_type = params[:type]
    
    case @request_type
    when 'gift'
      @item = Item.find(params[:item_id])
    when 'monster_invite'
      @item = Monster.find(params[:monster_id])
    end
    
    @requests = Array.wrap(params[:ids])

    @requests.each do |request_id|
      AppRequest::Base.create(:facebook_id => request_id)
    end

    render :layout => 'ajax'
  end
  
  def update
    @app_request = current_character.app_requests.find(params[:id])

    @app_request.accept
      
    render :layout => 'ajax'
  end
end
