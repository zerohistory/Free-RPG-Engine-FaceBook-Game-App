module Payouts
  class UpgradePoint < Base
    def apply(character, reference = nil)
      if action == :remove
        character.points -= @value
        character.points = 0 if character.points < 0
      else
        character.points += @value
      end
    end
  end
end
