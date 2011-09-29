module News
  class MissionComplete < Base
    def mission
      @mission ||= Mission.find(data[:mission_id])
    end

    def level_rank
      @level_rank ||= MissionLevelRank.find(data[:level_rank_id], :include => :level)
    end
  end
end
