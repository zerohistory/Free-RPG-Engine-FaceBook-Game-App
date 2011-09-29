module Payouts
  class BasicMoney < Base
    def apply(character, reference = nil)
      if action == :remove
        character.charge(@value, 0, reference)
      else
        character.charge(- @value, 0, reference)
      end
    end

    def to_s
      I18n.t("payouts.basic_money.value", :value => @value)
    end
  end
end
