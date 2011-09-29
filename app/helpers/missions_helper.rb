module MissionsHelper
  def mission_list(missions)
    missions.each do |mission|
      if mission.visible_for?(current_character)
        rank = current_character.mission_levels.rank_for(mission)
        level = rank ? rank.level : mission.levels.first

        yield(mission, level, rank)
      end
    end
  end

  def mission_progress(rank, options = {})
    options = options.reverse_merge(
      :level => true
    )

    result = ""

    if options[:level] and rank.mission.levels.size > 1
      result << content_tag(:div, t("missions.mission.level", :level => rank.level.position), :class => :level)
    end

    if rank.nil?
      result << percentage_bar(0,
        :label => "%s: %d%" % [Mission.human_attribute_name("progress"), 0]
      )
    elsif rank.completed?
      result << percentage_bar(100, :label => t("missions.mission.completed"))
    else
      percentage = rank.progress_percentage

      result << percentage_bar(percentage,
        :label => "%s: %d%" % [Mission.human_attribute_name("progress"), percentage]
      )
    end

    result.html_safe
  end

  def mission_money(level)
    "%s - %s" % [number_to_currency(level.money_min), number_to_currency(level.money_max)]
  end
end
