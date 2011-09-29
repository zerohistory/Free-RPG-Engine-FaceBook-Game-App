module Payouts
  class RandomItem < Base
    attr_accessor :item, :availability, :allow_vip, :item_set_id, :shift_item_set

    def item_set
      @item_set ||= (@item_set_id ? ItemSet.find_by_id(@item_set_id) : nil)
    end

    def item_set_id=(value)
      @item_set_id = value.to_i
    end

    def apply(character, reference = nil)
      if @item = choose_item(character)
        character.inventories.give!(@item)
      end
    end
    
     def apply_ownerships(character, current_character,reference = nil)
	  @i=0
	   check_condition(character, current_character)
	   character.inventories.give!(@item) 
           
     end
     
      def check_condition(character, current_character)
	      @item = choose_item(character) 

		 if (@item.ownerships.collect(&:character_type_id).include?(current_character.character_type.id) == true || @item.ownerships.blank?)
			 @i=0
			return @item
		else
                    return @item=nil if @item_set.size == @i
		     check_condition(character, current_character)
		     @i+=1
                                                   
		       
		end
      end
      

    def item_ids
      Array.wrap(@item_ids).collect{|id| id.to_i }
    end

    def allow_vip=(value)
      @allow_vip = (value.to_i == 1)
    end

    def shift_item_set=(value)
      @shift_item_set = (value.to_i == 1)
    end

    protected

    def choose_item(character)
      if item_set
        item_set.random_item(shift_item_set ? character.id % item_set.size : 0)
      else
        scope = ::Item.with_state(:visible)
        scope = scope.available_in(availability) unless availability.blank?
        scope = scope.basic unless allow_vip

        scope.first(
          :conditions => ["basic_price <= ?", value],
          :order => "RAND()"
        )
      end
    end
  end
end
