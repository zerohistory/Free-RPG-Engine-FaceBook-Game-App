class MonstersController < ApplicationController
  def index
    @monsters       = current_character.monsters.current
    @monster_types  = current_character.monster_types.available_for_fight
  end

  def show
    if params[:key].present?
      @monster = Monster.find(encryptor.decrypt(params[:key].to_s))
    else
      @monster = current_character.monsters.find(params[:id])
    end

    @fight = @monster.monster_fights.find_or_initialize_by_character_id(current_character.id)
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    Rails.logger.error "Failed to decrypt monster ID: #{ params[:id] }"

    redirect_from_exception
  end

  def new
    @monster_type = MonsterType.find(params[:monster_type_id])

    @monster = current_character.monsters.current.by_type(@monster_type).first
    @monster ||= @monster_type.monsters.create!(:character => current_character)

    redirect_from_iframe monster_url(@monster, :canvas => true)
  end

  def update
    @fight = Monster.find(params[:id]).monster_fights.find_or_initialize_by_character_id(current_character.id)

    @attack_result = @fight.attack!

    render :layout => 'ajax'
  end

  def reward
    @fight = current_character.monster_fights.find_by_monster_id(params[:id])

    @reward_collected = @fight.collect_reward!

    render :layout => 'ajax'
  end
end
