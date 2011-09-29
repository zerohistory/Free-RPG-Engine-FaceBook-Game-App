module Payouts
  class DefencePointsTotal < Base
    def apply(character, reference = nil)
      if action == :remove
        character.defence -= @value
      else
        character.defence += @value
      end
    end
  end
end
