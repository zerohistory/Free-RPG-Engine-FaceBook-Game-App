module Requirements
  class EnergyPoint < Base
    def satisfies?(character)
      character.ep >= @value
    end
  end
end
