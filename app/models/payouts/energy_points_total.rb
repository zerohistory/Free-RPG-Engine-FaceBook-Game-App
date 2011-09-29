module Payouts
  class EnergyPointsTotal < Base
    def apply(character, reference = nil)
      if action == :remove
        character.energy -= @value
      else
        character.energy += @value
      end
    end
  end
end
