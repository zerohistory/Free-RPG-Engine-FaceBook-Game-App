class Character
  module Inventories
    def self.included(base)
      base.class_eval do
        has_many :inventories,
          :include    => :item,
          :dependent  => :delete_all,
          :extend     => AssociationExtension

        has_many :items, :through => :inventories
      end
    end


    module AssociationExtension
      def give(item, amount = 1)
        amount = amount.to_i
		  if item
			if item.requirements_satisfied?(proxy_owner) and inventory = find_by_item(item)
			  inventory.amount += amount
			else
			  inventory = build(:item => item, :amount => amount)
			  inventory.character = proxy_owner
			end
		 
			inventory
		 end	
      end

      def give!(item, amount = 1)
        inventory = give(item, amount)

        transaction do
          if inventory && inventory.save
            Item.update_counters(inventory.item_id, :owned => amount)

            equip!(inventory)
          end
        end

        inventory
      end

      def buy!(item, amount = 1)
        effective_amount = amount * item.package_size

        inventory = give(item, effective_amount)

        inventory.charge_money = true

        transaction do
          if inventory.save and proxy_owner.save
            Item.update_counters(inventory.item_id, :owned => effective_amount)

            equip!(inventory)

            proxy_owner.news.add(:item_purchase, :item_id => item.id, :amount => effective_amount)
          end
        end

        inventory
      end

      def sell!(item, amount = 1)
        if inventory = find_by_item(item)
          inventory.deposit_money = true
          
          take!(inventory, amount)
        else
          false
        end
      end

      def take!(item, amount = 1)
        if inventory = find_by_item(item)
          transaction do
            if inventory.amount > amount
              inventory.amount -= amount
              
              inventory.save
            else
              amount = inventory.amount
              
              inventory.destroy
            end

            Item.update_counters(inventory.item_id, :owned => - amount)
            
            proxy_owner.save

            unequip!(inventory)
          end

          inventory
        else
          false
        end
      end

      def transfer!(character, item, amount = 1)
        raise ArgumentError.new('Cannot transfer negative amount of items') if amount < 1
        raise ArgumentError.new('Source character doesn\'t have enough items') if find_by_item(item).amount < amount

        transaction do
          take!(item, amount)
          character.inventories.give!(item.is_a?(Inventory) ? item.item : item, amount)
        end
      end


      def gift(inventory, receiver, amount)
        item = inventory.item

        if inventory.amount > amount
          inventory.amount -= amount
          inventory.save
        else
          inventory.destroy
        end

        gifted_inventory = receiver.inventories.give(item, amount)
        if gifted_inventory.save
          Item.update_counters(item.id, :owned => amount)
        end
      end

      protected

      def find_by_item(item)
        inventory = item.is_a?(Inventory) ? item : find_by_item_id(item.id, :include => :item)

        inventory.try(:character=, proxy_owner)
      
        inventory
      end

      def equip!(inventory)
        return unless inventory.item.equippable?
        
        if Setting.b(:character_auto_equipment)
          proxy_owner.equipment.equip_best!(true)
        else
          proxy_owner.equipment.auto_equip!(inventory)
        end
      end

      def unequip!(inventory)
        return unless inventory.item.equippable?
        
        if Setting.b(:character_auto_equipment)
          proxy_owner.equipment.equip_best!(true)
        else
          proxy_owner.equipment.auto_unequip!(inventory)
        end
      end
    end
  end
end
