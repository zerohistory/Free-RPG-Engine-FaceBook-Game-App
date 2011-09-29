module News
  class PropertyUpgrade < Base
    def property
      @property ||= PropertyType.find(data[:property_id])
    end
    
    def level
      data[:level] || property.level
    end
  end
end
