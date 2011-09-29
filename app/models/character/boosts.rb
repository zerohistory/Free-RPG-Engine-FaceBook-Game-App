class Character
  class Boosts
    def initialize(character)
      @character = character
    end

    def inventories
      @inventories ||= @character.inventories.all(:joins => :item, :conditions => "boost = 1")
    end

    def best_attacking
      inventories.select{|i| i.attack > 0 || i.health > 0 }.max_by{|i| [i.attack, i.health] }
    end

    def best_defending
      inventories.select{|i| i.defence > 0 || i.health > 0 }.max_by{|i| [i.defence, i.health] }
    end

    def best_energy
      inventories.select{|i| i.energy > 0 }.max_by{|i| i.energy }
    end
  end
end
