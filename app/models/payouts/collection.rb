module Payouts
  class Collection
    attr_reader :items

    delegate :<<, :shift, :unshift, :each, :empty?, :any?, :size, :first, :last, :[], :detect, :include?, :to => :items

    def self.parse(collection)
      return if collection.nil?

      if collection.is_a?(Payouts::Collection)
        collection
      else
        items = collection.values.sort_by{|v| v["position"].to_i }.collect do |payout|
          payout.symbolize_keys!

          Payouts::Base.by_name(payout[:type]).new(payout.except(:type, :position))
        end

        new(*items)
      end
    end

    def initialize(*payouts)
      @items = payouts
    end

    def apply(character, trigger, reference = nil)
      Payouts::Collection.new.tap do |result|
        items.each do |payout|
          if payout.applicable?(*trigger)
            payout.apply(character, reference)
            result.items << payout
          end
        end
      end
    end
    
    
       def apply_for_ownerships(character, trigger, current_character, reference = nil)
      Payouts::Collection.new.tap do |result|
        items.each do |payout|
          if payout.applicable?(*trigger)
            payout.apply_ownerships(character, current_character, reference)  
            result.items << payout 
          end
        end
      end
    end
    
    

    def by_action(action)
      items.select{|p| p.action == action }
    end

    def visible?
      !items.detect{|i| i.visible }.nil?
    end

    def +(other)
      Payouts::Collection.new.tap do |result|
        result.items.push(*items)
        result.items.push(*other.items)
      end
    end

    def to_s
      items.collect{|i| i.to_s}.join(", ")
    end
  end
end
