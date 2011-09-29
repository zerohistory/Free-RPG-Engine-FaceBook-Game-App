module Payouts
  class RandomProperty < Base
    attr_accessor :property, :property_set_id, :shift_property_set

    def property_set
      @property_set ||= (@property_set_id ? PropertySet.find_by_id(@property_set_id) : nil)
    end

    def property_set_id=(value)
      @property_set_id = value.to_i
    end

    def apply(character, reference = nil)
      if @property = choose_property
        character.properties.give!(@property)
      end
    end

    def property_ids
      Array.wrap(@property_ids).collect{|id| id.to_i }
    end

    def shift_property_set=(value)
      @shift_property_set = (value.to_i == 1)
    end
    
    protected
    
    def choose_property
      if property_set
        property_set.random_property(shift_property_set ? character.id % property_set.size : 0)
      end
    end
  end
end
