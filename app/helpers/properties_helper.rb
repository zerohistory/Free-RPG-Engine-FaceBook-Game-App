module PropertiesHelper
  def property_type_list(types, properties, &block)
    result = ""

    types.each do |type|
      property = properties.detect{|p| p.property_type == type }

      next if property.nil? and (type.availability != :shop or !type.visible?)

      result << capture(type, property, &block)
    end

    concat(result.html_safe)
  end

  def property_image(property, format)
    if property.image?
      image_tag(property.image.url(format), :alt => property.name, :title => property.name)
    else
      property.name
    end
  end
end
