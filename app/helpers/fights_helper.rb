module FightsHelper
  def fight_description(fight)
    t("fights.descriptions.#{ fight.attacker == current_character ? "attack" : "defence" }_#{ fight.winner == current_character ? "won" : "lost" }",

      :attacker           => character_name_link(fight.attacker, {}, {:useyou => true, :capitalize => fight.attacker == current_character}),
      :victim             => character_name_link(fight.victim, {}, {:useyou => true, :capitalize => fight.victim == current_character}),

      :money              => content_tag(:span, number_to_currency(fight.winner == current_character ? fight.winner_money : fight.loser_money),  :class => "attribute basic_money"),
      :experience_points  => content_tag(:span, fight.experience,                 :class => "attribute experience"),
      :attacker_damage    => content_tag(:span, fight.attacker_hp_loss,           :class => "attribute health"),
      :victim_damage      => content_tag(:span, fight.victim_hp_loss,             :class => "attribute health")
    ).html_safe
  end
end
