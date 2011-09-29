module Requirements
  class Attack < Base
    def satisfies?(character)
      character.attack >= @value
    end
  end
end
