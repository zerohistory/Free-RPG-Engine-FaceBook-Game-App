class MissionGroupRank < ActiveRecord::Base
  belongs_to :character
  belongs_to :mission_group

  before_save   :cache_completion
  after_create  :assign_just_created

  def completed?
    self[:completed] || (missions_completed? && bosses_completed?)
  end

  def just_created?
    @just_created
  end

  protected

  def missions_completed?
    mission_group.missions.with_state(:visible).size <= character.missions.completed_ids(mission_group).size # Less or equal because mission can be hidden after completion
  end

  def bosses_completed?
    mission_group.bosses.with_state(:visible).size <= character.boss_fights.won_boss_ids(mission_group).size # Less or equal because boss can be hidden after completion
  end

  def cache_completion
    self.completed = missions_completed? && bosses_completed?

    true
  end

  def assign_just_created
    @just_created = true
  end
end
