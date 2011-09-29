module Payouts
  class HealthPointsTotal < Base
    def apply(character, reference = nil)
      if action == :remove
        character.health -= @value
      else
        character.health += @value
      end
    end
  end
end
