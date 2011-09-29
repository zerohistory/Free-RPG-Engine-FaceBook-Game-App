class MissionRank < ActiveRecord::Base
  belongs_to :character
  belongs_to :mission
  belongs_to :mission_group

  before_create :assign_group
  before_save :cache_completion

  def completed?
    self[:completed] || levels_completed?
  end

  protected

  def assign_group
    self.mission_group_id = mission.mission_group_id
  end

  def levels_completed?
    mission.levels.size == character.mission_levels.completed_ids(mission).size
  end

  def cache_completion
    self.completed = levels_completed?

    true
  end
end
