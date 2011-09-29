class Character
  module Collections
    def self.included(base)
      base.class_eval do
        has_many :collection_ranks,
          :class_name => "ItemCollectionRank",
          :extend     => CollectionRankAssociationExtension

        has_many :collections,
          :class_name => "ItemCollection",
          :through    => :collection_ranks,
          :extend     => CollectionAssociationExtension
      end
    end

    module CollectionRankAssociationExtension
      def rank_for(collection)
        proxy_owner.collection_ranks.find_by_collection_id(collection.id) || proxy_owner.collection_ranks.build(:collection => collection)
      end
    end

    module CollectionAssociationExtension
      def apply!(collection)
        proxy_owner.collection_ranks.rank_for(collection).tap do |rank|
          rank.apply!
        end
      end

      def next_payout_triggers(collection)
        if proxy_owner.collection_ranks.rank_for(collection).collected?
          [:repeat_collected]
        else
          [:collected]
        end
      end
    end
  end
end
