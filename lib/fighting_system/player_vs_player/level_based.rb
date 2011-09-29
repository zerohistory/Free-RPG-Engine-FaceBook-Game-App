module FightingSystem
  module PlayerVsPlayer
    module LevelBased
      def self.calculate(attacker, victim)
        if attacker.level - victim.level > Setting.i(:fight_level_threshold)
          rand(1000) > Setting.i(:fight_level_theshold_chance) * 10
        elsif victim.level - attacker.level > Setting.i(:fight_level_threshold)
          rand(1000) < Setting.i(:fight_level_theshold_chance) * 10
        else
          attack_points   = attacker.attack_points
          defence_points  = victim.defence_points

          attack_bonus    = 1.0
          defence_bonus   = 1.0

          attack  = attack_points * attack_bonus * 50
          defence = defence_points * defence_bonus * 50

          (rand((attack + defence).to_i) >= defence)
        end
      end
    end
  end
end
