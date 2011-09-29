module RequirementsHelper
  def requirement_list(requirements, filter = nil)
    result = ""

    requirements.each do |requirement|
      next if filter == :unsatisfied and requirement.satisfies?(current_character)

      result << render("requirements/#{requirement.name}",
        :requirement  => requirement,
        :satisfied    => requirement.satisfies?(current_character)
      )
    end

    result.html_safe
  end

  def requirement(*args, &block)
    type      = args.shift
    value     = block_given? ? capture(&block) : args.shift
    satisfied = args.first

    result = content_tag(:div, value.html_safe, :class => "requirement #{type} #{"not_satisfied" unless satisfied}")

    block_given? ? concat(result) : result
  end

  def unsatisfied_requirement_list(requirements)
    result = ""

    requirements.each do |requirement|
      next if requirement.satisfies?(current_character)

      result << render("requirements/not_satisfied/#{requirement.name}",
        :requirement  => requirement
      )
    end

    result.html_safe
  end

  def attribute_requirement_text(attribute, value)
    t("requirements.attribute.text",
      :amount => content_tag(:span, value, :class => :value),
      :name   => Character.human_attribute_name(attribute.to_s)
    ).html_safe
  end

  def attribute_requirement(attribute, value, satisfied = true)
    requirement(attribute, attribute_requirement_text(attribute, value), satisfied)
  end

  def vip_money_requirement(value)
    requirement(:vip_money,
      "%s (%s)" %[
        attribute_requirement_text(:vip_money, number_to_currency(value)),
        link_to(t("premia.get_vip"), premium_path)
      ],
      current_character.vip_money >= value
    )
  end
end
