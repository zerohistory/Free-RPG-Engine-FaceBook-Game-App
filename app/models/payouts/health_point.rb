module Payouts
  class HealthPoint < Base
    def apply(character, reference = nil)
      if action == :remove
        character.hp -= @value
      else
        character.hp += @value
      end
    end
  end
end
