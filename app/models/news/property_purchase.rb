module News
  class PropertyPurchase < Base
    def property
      @property ||= PropertyType.find(data[:property_id])
    end
  end
end
