module Payouts
  class Mercenary < Base
    attr_reader :mercenaries

    def apply(character, reference = nil)
      @mercenaries = []

      @value.times do
        if action == :remove
          if mercenary = character.mercenary_relations.first
            mercenary.destroy
          end

          @mercenaries << mercenary
        else
          @mercenaries << character.mercenary_relations.create
        end
      end
    end
  end
end
