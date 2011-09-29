module Requirements
  class RejectedProperty < Base
    def value=(value)
      @value = value.is_a?(::PropertyType) ? value.id : value.to_i
    end

    def property
      ::PropertyType.find_by_id(value)
    end

    def satisfies?(character)
      !character.has_property?(property)
    end
  end
end
