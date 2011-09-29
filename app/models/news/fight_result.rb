module News
  class FightResult < Base
    def fight
      @fight ||= Fight.find(data[:fight_id])
    end
  end
end
