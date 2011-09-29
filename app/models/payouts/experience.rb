module Payouts
  class Experience < Base
    def apply(character, reference = nil)
      character.experience += @value
    end
  end
end
