class Character
  module Premium
    def exchange_money!
      return if vip_money < Setting.i(:premium_money_price)

      charge!(- Setting.i(:premium_money_amount), Setting.i(:premium_money_price), :premium_money)
    end
    
    def refill_energy!(free = false)
      return if full_ep? or (!free and vip_money < Setting.i(:premium_energy_price))

      self.ep = energy_points

      free ? save : charge!(0, Setting.i(:premium_energy_price), :premium_energy)
    end

    def refill_health!(free = false)
      return if full_hp? or (!free and vip_money < Setting.i(:premium_health_price))

      self.hp = health_points

      free ? save : charge!(0, Setting.i(:premium_health_price), :premium_health)
    end

    def refill_stamina!(free = false)
      return if full_sp? or (!free and vip_money < Setting.i(:premium_stamina_price))

      self.sp = stamina_points

      free ? save : charge!(0, Setting.i(:premium_stamina_price), :premium_stamina)
    end

    def buy_points!
      return if vip_money < Setting.i(:premium_points_price)

      self.points += Setting.i(:premium_points_amount)

      charge!(0, Setting.i(:premium_points_price), :premium_points)
    end

    def hire_mercenary!
      return if vip_money < Setting.i(:premium_mercenary_price)

      transaction do
        charge!(0, Setting.i(:premium_mercenary_price), :premium_mercenary)

        mercenary_relations.create!
      end
    end

    def reset_attributes!
      return if vip_money < Setting.i(:premium_reset_attributes_price)

      free_points = 0

      UPGRADABLE_ATTRIBUTES.each do |attribute|
        current_value = self[attribute]
        new_value     = character_type[attribute]

        free_points += (current_value - new_value) *
          Setting.i("character_#{attribute}_upgrade_points") /
          Setting.i("character_#{attribute}_upgrade")

        self[attribute] = new_value
      end

      self.points += free_points

      self.hp = health_points if hp > health_points
      self.ep = energy_points if ep > energy_points
      self.sp = stamina_points if sp > stamina_points

      charge!(0, Setting.i(:premium_reset_attributes_price), :premium_reset_attributes)
    end

    def change_name!
      return if vip_money < Setting.i(:premium_change_name_price)

      charge!(0, Setting.i(:premium_change_name_price), :premium_change_name)
    end
  end
end