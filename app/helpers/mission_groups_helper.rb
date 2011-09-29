module MissionGroupsHelper
  class GroupTabBuilder
    attr_reader :template

    delegate :dom_id, :dom_class, :content_tag, :capture, :concat, :javascript_tag, :current_character, :to => :template

    def initialize(template)
      @template = template
    end

    def previous_tab(&block)
      @previous_group = block
    end

    def next_tab(&block)
      @next_group = block
    end

    def group_tab(&block)
      @group = block
    end

    def groups
      @groups ||= MissionGroup.with_state(:visible).select do |group|
        !group.hide_unsatisfied? || group.requirements.satisfies?(current_character)
      end
    end

    def html
      return if groups.empty?

      yield(self)

      current_group   = current_character.mission_groups.current

      previous_group  = capture(&@previous_group)
      next_group      = capture(&@next_group)

      result = ""

      groups.each do |group|
        locked  = !group.requirements.satisfies?(current_character)

        result << content_tag(:li, capture(group, locked, &@group),
          :id     => dom_id(group),
          :class  => [dom_class(group), (:locked if locked)].compact.join(" ")
        )
      end

      result = content_tag(:div,
        [
          content_tag(:div, previous_group, :class => :previous),
          content_tag(:div, next_group, :class => :next),
          content_tag(:div, content_tag(:ul, result.html_safe, :class => :clearfix), :class => :container)
        ].join(" ").html_safe,
        :id     => :mission_group_list,
        :class  => :clearfix
      ) + javascript_tag("$(function(){ $('#mission_group_list').missionGroups('##{dom_id(current_group)}', #{Setting.i(:mission_group_show_limit)}) });")

      block_given? ? concat(result) : result
    end
  end

  def mission_group_tabs(&block)
    GroupTabBuilder.new(self).html(&block)
  end
end
