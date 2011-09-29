module Admin::PropertyTypesHelper
  def property_type_tag(property_type)
    content_tag(:div, :class => "property_type") do
      property_image(property_type, :icon) <<
      content_tag(:span, property_type.name)
    end
  end
end
