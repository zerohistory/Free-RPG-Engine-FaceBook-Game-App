module Payouts
  class Item < Base
    def value=(value)
      @value = value.is_a?(::Item) ? value.id : value.to_i
    end

    def amount=(value)
      @amount = value.to_i
    end

    def amount
      @amount || 1
    end

    def item
      ::Item.find_by_id(value)
    end

    def apply(character, reference = nil)
	      if action == :remove
		character.inventories.take!(item, amount)
	      else
		character.inventories.give!(item, amount)
	      end
    end
    
      def apply_ownerships(character, current_character, reference = nil)
	       if action == :remove
		character.inventories.take!(item, amount)
	      else
		character.inventories.give!(item, amount)
	      end
    end
    
    
  end
end
