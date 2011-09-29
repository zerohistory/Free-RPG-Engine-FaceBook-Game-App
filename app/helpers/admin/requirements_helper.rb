module Admin::RequirementsHelper
  def admin_requirements_preview(requirements)
    result = ""

    requirements.each do |requirement|
      result << render("admin/requirements/preview/#{requirement.name}", :requirement => requirement)
    end

    result.html_safe
  end
end
