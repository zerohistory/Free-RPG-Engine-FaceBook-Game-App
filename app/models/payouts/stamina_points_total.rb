module Payouts
  class StaminaPointsTotal < Base
    def apply(character, reference = nil)
      if action == :remove
        character.stamina -= @value
      else
        character.stamina += @value
      end
    end
  end
end
