module InventoriesHelper
  def inventory_additonal_slots_note
    free_slots = current_character.equipment.available_capacity(:additional)

    yield(free_slots)
  end

  def inventory_free_slots_note
    return if Setting.b(:character_auto_equipment)

    free_slots = current_character.equipment.free_slots

    if free_slots > 0 and current_character.inventories.equippable.size > 0
      yield(free_slots)
    end
  end

  def inventory_use_button(inventory)
    button(
      inventory.use_button_label.blank? ? t('inventories.list.buttons.use') : inventory.use_button_label
    )
  end
end
