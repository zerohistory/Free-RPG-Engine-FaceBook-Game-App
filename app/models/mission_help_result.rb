class MissionHelpResult < ActiveRecord::Base
  belongs_to :character
  belongs_to :requester, :class_name => 'Character'
  belongs_to :mission
  
  before_create :give_payout
  
  class << self
    def characters
      all(:include => :character).collect{|r| r.character }
    end
  end
  
  protected
  
  def validate_on_create
    errors.add_to_base(:already_helped) if character.mission_help_results.find_by_requester_id_and_mission_id(requester_id, mission_id)
    errors.add_to_base(:cannot_help_themself) if character_id == requester_id
  end

  def give_payout
    level = requester.mission_levels.rank_for(mission).level

    self.basic_money  = Setting.p(:mission_help_money, level.money).ceil
    self.experience   = Setting.p(:mission_help_experience, level.experience).ceil

    character.experience += experience

    character.charge!(- basic_money, 0, self)
  end
end
