module BossFightsHelper
  def boss_fight_health_bar(fight)
    percentage = fight.health.to_f / fight.boss.health * 100

    percentage_bar(percentage,
      :label => "%s: %d/%d" % [
        Boss.human_attribute_name("health"),
        fight.health,
        fight.boss.health
      ]
    )
  end
end
