module Requirements
  class Defence < Base
    def satisfies?(character)
      character.defence >= @value
    end
  end
end
