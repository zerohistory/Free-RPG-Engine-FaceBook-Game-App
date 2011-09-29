module Requirements
  class Level < Base
    def satisfies?(character)
      character.level >= @value
    end
  end
end
