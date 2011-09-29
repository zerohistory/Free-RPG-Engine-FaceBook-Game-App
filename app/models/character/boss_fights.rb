class Character
  module BossFights
    def won?(boss)
      won_boss_ids(boss.mission_group).include?(boss.id)
    end

    def won_boss_ids(group)
      with_state(:won).all(
        :select     => "DISTINCT boss_id",
        :joins      => :boss,
        :conditions => ["mission_group_id = ?", group.id]
      ).collect{|f| f.boss_id }
    end

    def find_by_boss(boss)
      with_state(:progress).find_by_boss_id(boss.id) || build_by_boss(boss)
    end

    def build_by_boss(boss)
      build(:boss => boss).tap do |fight|
        fight.expire_at = Time.now + boss.time_limit.to_i.minutes if boss.time_limit?
        fight.health    = boss.health
      end
    end

    def next_payout_triggers(boss)
      if won?(boss)
        [:repeat_victory, :repeat_defeat]
      else
        [:victory, :defeat]
      end
    end
  end
end
