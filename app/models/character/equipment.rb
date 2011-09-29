class Character::Equipment
  MAIN_PLACEMENTS = [:left_hand, :right_hand, :head, :body, :legs]
  PLACEMENTS = MAIN_PLACEMENTS + [:additional]

  # A set of placements to be enabled by default
  DEFAULT_PLACEMENTS = []

  IMAGE_SIZES = {
    :left_hand  => :medium,
    :right_hand => :medium,
    :head       => :small,
    :body       => :medium,
    :legs       => :medium,
    :additional => :small
  }
  
  class << self
    def placement_name(name)
      I18n.t("inventories.placements.names.#{name}", :default => name.to_s.humanize)
    end
  end


  def initialize(character)
    @character = character
    @cache = Rails.cache
  end

  # Item can have assigned elements, these elements interact with elements on victim's items
  # For example, attacker has knife with 5 Fires and his victim has shield with 3 Water.
  # This knife give attacker +2 to attack. Otherwise, if victim has shiled with 10 Water,
  # this will not drop attacker's attack to -5 points, water just blocks fire elements
  def elements_effects(victim = nil)
    return 0 unless victim

    elements_count = sum_elements(:attack)
    victim_elements_count = victim.equipment.sum_elements(:defence)
    attack_bonus = 0

    elements_count.each_pair do |element_id, count|
      interactions = ElementInteraction.find(:all, :conditions => ["attack_element = ?", element_id])
      interactions.each do |interaction|
        diff = (count * interaction.factor) - victim_elements_count[interaction.defence_element]
        attack_bonus += diff if diff > 0
      end
    end

    attack_bonus
  end

  def effect(name)
    @effects ||= @cache.read(effect_cache_key)
    
    unless @effects
      @effects = {}

      Item::EFFECTS.each do |effect|
        @effects[effect] = inventories.sum do |i|
          if i.item.usage_type == "all" || i.item.usage_type == effect.to_s
            i.send(effect)
          else
            0
          end
        end
      end
      
      @cache.write(effect_cache_key, @effects, :expire_in => 15.minutes)
    end

    @effects[name.to_sym]
  end
  

  def sum_elements(type)
    elements = Element.to_empty_hash
    inventories.each do |i|
      if i.item.usage_type == "all" || i.item.usage_type == type.to_s
        i.item.item_elements.send(type).each do |e|
          elements[e.element_id] += e.count
        end
      end
    end

    elements
  end

  def inventories
    unless @inventories
      ids = @character.placements.values.flatten

      if ids.any?
        inventories = Inventory.find_all_by_id(ids.uniq.sort, :include => :item)

        # Sorting inventories by ID order
        @inventories = ids.collect do |id|
          inventories.detect{|inventory| inventory.id == id}
        end
      else
        @inventories = []
      end
    end

    @inventories
  end
  

  def inventories_by_placement(placement)
    Array.wrap(@character.placements[placement.to_sym]).collect do |id|
      inventories.detect{|i| i.id == id}
    end
  end
  

  def equip(inventory, placement)
    placement = placement.to_sym

    return unless inventory.placements.include?(placement) && inventory.equippable?

    previous = nil
    
    if available_capacity(placement) > 0
      @character.placements[placement] ||= []
      @character.placements[placement] << inventory.id

      inventory.equipped = equipped_amount(inventory)
    elsif MAIN_PLACEMENTS.include?(placement) # Main placements can be replaced
      previous = @character.inventories.find(@character.placements[placement].last)
      
      unless previous == inventory # Do not re-equip the same inventory
        unequip(previous, placement)
        equip(inventory, placement)
      end
    end
    
    @inventories = nil
    
    previous
  end
  

  def unequip(inventory, placement)
    placement = placement.to_sym

    if @character.placements[placement] and index = @character.placements[placement].index(inventory.id)
      @character.placements[placement].delete_at(index)

      inventory.equipped = equipped_amount(inventory) unless inventory.frozen?
    end
    
    @inventories = nil
  end


  def equip!(inventory, placement)
    Character.transaction do
      previous = equip(inventory, placement)

      previous.try(:save)
      
      inventory.save
      @character.save!
      
      clear_effect_cache!
    end
  end
  

  def unequip!(inventory, placement)
    Character.transaction do
      unequip(inventory, placement)

      inventory.save
      @character.save!
      
      clear_effect_cache!
    end
  end


  def auto_equip(inventory, amount = nil)
    amount ||= inventory.amount_available_for_equipment
    
    amount.times do
      if placement = (placements_with_free_slots & inventory.placements).first
        equip(inventory, placement)
      else
        break
      end
    end
  end


  def auto_equip!(inventory, amount = nil)
    Character.transaction do
      auto_equip(inventory, amount)

      inventory.save

      @character.save!
      
      clear_effect_cache!
    end
  end


  def auto_unequip(inventory)
    amount_to_unequip = inventory.destroyed? ? inventory.amount : (inventory.equipped - inventory.amount)

    return if amount_to_unequip <= 0

    amount_to_unequip.times do
      if placement = equipped_slots(inventory).last
        unequip(inventory, placement)
      else
        break
      end
    end
  end


  def auto_unequip!(inventory)
    Character.transaction do
      auto_unequip(inventory)

      inventory.save unless inventory.destroyed?

      @character.save!
      
      clear_effect_cache!
    end
  end


  def equip_best!(force_unequip = false)
    unequip_all! if force_unequip

    equippables = @character.inventories.equippable.all

    Character.transaction do
      while free_slots > 0
        equipped = nil

        Item::EFFECTS.each do |effect|
          candidates = equippables.select{|i| i.equippable? and i.send(effect) != 0}

          if inventory = candidates.max_by{|i| [i.send(effect), i.effects.values.sum]} and auto_equip(inventory, 1)
            equipped = inventory
          end
        end

        break if equipped == nil
      end

      equippables.each do |inventory|
        inventory.save if inventory.changed?
      end

      @character.save!
      
      clear_effect_cache!
    end
  end


  def unequip_all!
    Character.transaction do
      @character.inventories.equipped.update_all(:equipped => 0)

      @character.placements = {}
      @character.save!
      
      clear_effect_cache!
    end
  end


  def free_slots
    PLACEMENTS.sum{|placement| available_capacity(placement) }
  end


  def available_capacity(placement)
    placement_capacity(placement) - used_capacity(placement)
  end
  

  def best_offence
    inventories.group_by{|i| i.item.item_group_id }.values.collect do |group|
      group.max_by{|i| i.attack }
    end
  end


  def best_defence
    inventories.group_by{|i| i.item.item_group_id }.values.collect do |group|
      group.max_by{|i| i.defence }
    end
  end
  
  protected
  
  def effect_cache_key
    "character_#{ @character.id }_equipment_effects"
  end

  def clear_effect_cache!
    @cache.delete(effect_cache_key)
    
    @effects = nil
    
    true
  end
  
  def equipped_amount(inventory)
    @character.placements.values.flatten.count(inventory.id)
  end
  
  def placements_with_free_slots
    PLACEMENTS.select{|placement| available_capacity(placement) > 0 }
  end
  
  def placement_capacity(placement)
    if placement == :additional
      result = @character.character_type.try(:equipment_slots) || Setting.i(:character_equipment_slots)

      result += @character.relations.effective_size / Setting.i(:character_relations_per_equipment_slot)
    else
      1
    end
  end
  
  def equipped_slots(inventory)
    PLACEMENTS.select{|placement| @character.placements[placement].try(:include?, inventory.id) }
  end
  
  def used_capacity(placement)
    @character.placements[placement].try(:size).to_i
  end
end
