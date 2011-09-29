module Requirements
  class RejectedItem < Base
    def value=(value)
      @value = value.is_a?(::Item) ? value.id : value.to_i
    end

    def item
      ::Item.find_by_id(value)
    end

    def satisfies?(character)
      !character.has_item?(item)
    end
  end
end
