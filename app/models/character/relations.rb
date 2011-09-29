class Character
  module Relations
    def self.included(base)
      base.class_eval do
        has_many :relations,
          :foreign_key  => "owner_id",
          :order        => "type",
          :extend       => RelationsAssociationExtension
        has_many :friend_relations,
          :foreign_key  => "owner_id",
          :include      => :character,
          :dependent    => :destroy,
          :extend       => FriendRelationsAssociationExtension
        has_many :mercenary_relations,
          :foreign_key  => "owner_id",
          :dependent    => :delete_all,
          :extend       => MercenaryRelationsAssociationExtension
      end
    end
    
    module RelationsAssociationExtension
      def effective_size
        maximum_size? ? Setting.i(:relation_max_alliance_size) : size + 1
      end

      def maximum_size?
        size + 1 >= Setting.i(:relation_max_alliance_size)
      end
    end
    
    module FriendRelationsAssociationExtension
      def establish!(target)
        transaction do
          create(:character => target)
          target.friend_relations.create(:character => proxy_owner)
        end
      end
      
      def character_ids
        all(:select => "character_id").collect{|r| r[:character_id] }
      end

      def facebook_ids
        all(:include => {:character => :user}).collect{|r|
          r.character.user.facebook_id
        }
      end

      def with(character)
        first(:conditions => {:character_id => character.id})
      end

      def established?(character)
        !with(character).nil?
      end

      def random
        first(:offset => rand(size)) if size > 0
      end
    end
    
    module MercenaryRelationsAssociationExtension
      def random
        first(:offset => rand(size)) if size > 0
      end
    end

    def can_accept(item = nil)
      return proxy_owner.relations unless item

      return proxy_owner.relations.collect do |r|
        item.requirements_satisfied?(r.character) ? r : nil
      end.compact
    end
  end
end
