module Requirements
  class HealthPoint < Base
    def satisfies?(character)
      character.hp >= @value
    end
  end
end
