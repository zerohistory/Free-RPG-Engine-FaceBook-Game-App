module FightingSystem
  module PlayerVsPlayer
    module MaxDifference
      def self.calculate(attacker, victim)
        attack_points   = attacker.attack_points
        defence_points  = victim.defence_points

        attack_bonus    = 1.0
        defence_bonus   = 1.0

        attack  = attack_points * attack_bonus * 50
        defence = defence_points * defence_bonus * 50

        if attack - defence > Setting.p(:fight_max_difference, attack)
          true
        else
          (rand((attack + defence).to_i) >= defence)
        end
      end
    end
  end
end
