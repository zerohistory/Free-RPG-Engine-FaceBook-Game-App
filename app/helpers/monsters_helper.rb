module MonstersHelper
  def monster_image(monster, format, options = {})
    if monster.image?
      image_tag(monster.image.url(format), options.reverse_merge(:alt => monster.name, :title => monster.name))
    else
      monster.name
    end
  end

  def monster_health_bar(monster)
    percentage = monster.hp.to_f / monster.health * 100

    percentage_bar(percentage,
      :label => '%s: <span class="value">%d/%d</span>' % [
        MonsterType.human_attribute_name("health"),
        monster.hp,
        monster.health
      ]
    )
  end

  def monster_list(monsters)
    monster_ids = monsters.collect{|m| m.id }

    fights = current_character.monster_fights.all(:conditions => {:monster_id => monster_ids})

    monsters.each do |monster|
      fight = fights.detect{|f| f.monster_id == monster.id }

      yield(monster, fight)
    end
  end
end
