module Payouts
  class AttackPointsTotal < Base
    def apply(character, reference = nil)
      if action == :remove
        character.attack -= @value
      else
        character.attack += @value
      end
    end
  end
end
