module Dice
  class << self
    def chance(value, base)
      rand(base) < value
    end
  end
end