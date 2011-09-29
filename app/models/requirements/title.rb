module Requirements
  class Title < Base
    def value=(value)
      @value = value.is_a?(::Title) ? value.id : value.to_i
    end

    def title
      @title ||= ::Title.find_by_id(value)
    end

    def satisfies?(character)
      character.titles.find_by_id(value)
    end
  end
end
