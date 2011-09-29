module AssignmentsHelper
  def assignment_effect(*attr)
    options = attr.extract_options!

    options.reverse_merge!(
      :format => :full
    )

    if attr.size == 1
      assignment = attr.first

      value = assignment.effect_value
    else
      assignment, relation = *attr

      value = Assignment.effect_value(assignment.context, relation, assignment.role)
    end

    t("assignments.roles.#{assignment.role}.effect.#{options[:format]}",
      :value => value
    )
  end
end
