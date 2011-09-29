class Character
  module Properties
    def self.included(base)
      base.class_eval do
        has_many :properties,
          :order      => "property_type_id",
          :dependent  => :delete_all,
          :extend     => AssociationExtension
      end
    end
    
    module AssociationExtension
      def give!(type)
        find_by_property_type_id(type.id) || create(:property_type => type)
      end

      def buy!(type)
        unless property = find_by_property_type_id(type.id)
          property = build(:property_type => type)

          property.buy!
        end

        property
      end

      def collect_money!
        result = Payouts::Collection.new

        transaction do
          each do |property|
            if collected = property.collect_money!
              result += collected
            end
          end
        end

        result.any? ? result : false
      end
  
    
      def collectable
        unless @collectable
          @collectable = []

          each do |property|
            @collectable << property if property.collectable?
          end
        end

        @collectable
    end
 


    end

    def gift!(property, receiver)
      receiver.properties.give!(property.property_type)
      property.destroy
    end
  end
end
