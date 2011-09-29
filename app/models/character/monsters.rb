class Character
  module Monsters
    def self.included(base)
      base.class_eval do
        has_many :monster_fights

        has_many :monsters,
          :through  => :monster_fights

        has_many :monster_types,
          :through  => :monsters,
          :extend   => MonsterTypeAssociationExtension
      end
    end

    module MonsterTypeAssociationExtension
      def available_for_fight
        scope = MonsterType.with_state(:visible).scoped(:conditions => ["level <= ?", proxy_owner.level])

        if exclude_ids = proxy_owner.monsters.current.collect{|m| m.monster_type_id } and exclude_ids.any?
          scope = scope.scoped(:conditions => ["id NOT IN (?)", exclude_ids])
        end

        scope
      end
    end
  end
end