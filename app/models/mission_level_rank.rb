class MissionLevelRank < ActiveRecord::Base
  belongs_to :character
  belongs_to :mission
  belongs_to :level, :class_name => "MissionLevel"

  before_create :assign_mission
  before_save   :check_completeness

  def just_completed?
    self.progress == level.win_amount
  end

  def progress_percentage
    (progress.to_f / level.win_amount * 100)
  end

  def next_payout_triggers
    if completed?
      mission.repeatable? ? [:repeat_success, :repeat_failure] : [:complete]
    elsif almost_completed?
      [:success, :failure, :complete]
    elsif
      [:success, :failure]
    end
  end

  def almost_completed?
    level.win_amount - progress == 1
  end

  protected

  def assign_mission
    self.mission = level.mission
  end

  def check_completeness
    self.completed = (progress >= level.win_amount)

    true
  end
end
