class RelationsController < ApplicationController
  def new
  end
  
  def create
    @character = Character.find(params[:character_id])
    
    current_character.friend_relations.establish!(@character)
    
    render :layout => 'ajax'
  end
  
  def index
    if current_character.relations.size == 0 and params[:noredirect].nil?
      redirect_from_iframe new_relation_url(:canvas => true)
    else
      @relations = fetch_relations
    end
  end
  
  def show
    @character = Character.find_by_invitation_key(params[:id])

    if @character.nil? or @character == current_character
      redirect_from_iframe root_url(:canvas => true)
    elsif current_character.friend_relations.established?(@character)
      flash[:notice] = t("relations.show.messages.already_joined")

      redirect_from_iframe root_url(:canvas => true)
    elsif Setting.b(:relation_friends_only) && !friend_with?(@character)
      flash[:notice] = t("relations.show.messages.only_friends")

      redirect_from_iframe root_url(:canvas => true)
    end
  end
  
  def destroy
    @target = Character.find(params[:id])

    FriendRelation.destroy_between(current_character, @target)

    @relations = fetch_relations

    render :layout => 'ajax'
  end

  protected

  def fetch_relations
    current_character.relations.paginate(
      :page     => params[:page],
      :per_page => Setting.i(:relation_show_limit)
    )
  end
  
  def friend_with?(character)
    current_user.friend_ids.include?(character.facebook_id) || 
    current_facebook_user.friends(:id).collect{|f| f.id }.include?(character.facebook_id)
  end
end
