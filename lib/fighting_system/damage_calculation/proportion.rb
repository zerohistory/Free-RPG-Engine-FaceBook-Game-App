module FightingSystem
  module DamageCalculation
    module Proportion
      def self.calculate(attacker, victim, attacker_won)
        attack_points   = attacker.attack_points
        defence_points  = victim.defence_points
        attack_bonus    = 1.0
        defence_bonus   = 1.0

        attack  = attack_points * attack_bonus * 50
        defence = defence_points * defence_bonus * 50

        if attacker_won
          victim_damage_reduce = 0.01 * victim.fight_damage_reduce

          attack_damage   = rand(Setting.p(:fight_max_loser_damage, victim.health * 1000)) * (1 - victim_damage_reduce)
          defence_damage  = rand(
            attack > defence ? (attack_damage * defence / attack) : Setting.p(:fight_max_winner_damage, attack_damage)
          )
        else
          attacker_damage_reduce = 0.01 * attacker.fight_damage_reduce

          defence_damage  = rand(Setting.p(:fight_max_loser_damage, attacker.health * 1000)) * (1 - attacker_damage_reduce)
          attack_damage   = rand(
            defence > attack ? (defence_damage * attack / defence) : Setting.p(:fight_max_winner_damage, defence_damage)
          )
        end

        attacker_boost_damage = attacker.boosts.best_attacking.try(:health) || 0
        victim_boost_damage = attacker.boosts.best_defending.try(:health) || 0

        [
          (attack_damage / 1000).ceil + attacker_boost_damage,
          (defence_damage / 1000).ceil + victim_boost_damage
        ]
      end
    end
  end
end
