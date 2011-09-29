module Requirements
  class StaminaPoint < Base
    def satisfies?(character)
      character.sp >= @value
    end
  end
end
