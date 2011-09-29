module News
  class MonsterFight < Base
    delegate :monster, :to => :monster_fight
    
    def monster_fight
      @monster_fight ||= ::MonsterFight.find(data[:monster_fight_id])
    end
  end
end
