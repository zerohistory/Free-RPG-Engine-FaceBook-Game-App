class StoriesController < ApplicationController
  def show
    story_data = encryptor.decrypt((params[:story_data] || params['amp;story_data']).to_s)
    
    if @story = Story.find_by_id(params[:id])
      @payouts = @story.track_visit!(current_character, story_data)
      
      key = @story.alias
    else
      @payouts = []
      key = params[:id]
    end
        
    @next_page = case key
    when 'item_purchased'
      items_url(:canvas => true)
    when 'mission_help'
      help_mission_url(story_data[:mission_id],
        :key => encryptor.encrypt(
          :mission_id   => story_data[:mission_id],
          :character_id => story_data[:character_id]
        ),
        :canvas => true
      )
    when 'mission_completed'
      mission = Mission.find(story_data[:mission_id])
      
      mission_group_url(mission.mission_group_id, :canvas => true)
    when 'boss_defeated'
      boss = Boss.find(story_data[:boss_id])
      
      mission_group_url(boss.mission_group_id, :canvas => true)
    when 'monster_invite', 'monster_defeated'
      monster_url(story_data[:monster_id], 
        :key => encryptor.encrypt(story_data[:monster_id]), 
        :canvas => true
      )
    when 'property'
      properties_url(:canvas => true)
    when 'promotion'
      promotion = Promotion.find(story_data[:promotion_id])
      
      promotion_url(promotion, :canvas => true)
    when 'hit_listing_new', 'hit_listing_completed'
      hit_listings_url(:canvas => true)
    when 'collection_completed'
      item_collections_url(:canvas => true)
    when 'collection_missing_items'
      give_inventories_url(
        :request_data => encryptor.encrypt(
          :items        => story_data[:items],
          :valid_till   => story_data[:valid_till],
          :character_id => story_data[:character_id]
        ),
        :canvas => true
      )
    else
      root_url(:canvas => true)
    end
    
    redirect_from_iframe(@next_page) if @payouts.empty?
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    Rails.logger.error "Failed to decrypt story data: #{params[:story_data]}"
    
    redirect_from_exception
  end
end
