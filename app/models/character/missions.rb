class Character
  module Missions
    def self.included(base)
      base.class_eval do
        has_many :mission_level_ranks,  :dependent => :delete_all, :extend => MissionLevelRanksExtension
        has_many :mission_ranks,        :dependent => :delete_all
        has_many :mission_group_ranks,  :dependent => :delete_all

        has_many :mission_levels,
          :through  => :mission_level_ranks,
          :source   => :level,
          :extend   => MissionLevelsExtension

        has_many :missions,
          :through  => :mission_ranks,
          :extend   => MissionAssociationExtension

        has_many :mission_groups,
          :through  => :mission_group_ranks,
          :extend   => MissionGroupAssociationExtension
          
        has_many :mission_help_results
        has_many :mission_helps, 
          :class_name   => "MissionHelpResult",
          :foreign_key  => :requester_id,
          :extend       => MissionHelpAssociationExtension
      end
    end

    module MissionLevelRanksExtension
      def incomplete_for(mission)
        first(
          :conditions => {
            :mission_id => mission.id,
            :completed  => false
          }
        )
      end
    end

    module MissionLevelsExtension
      def rank_for(mission)
        if incomplete = proxy_owner.mission_level_ranks.incomplete_for(mission)
          incomplete
        elsif proxy_owner.missions.completed?(mission)
          proxy_owner.mission_level_ranks.find_by_level_id(mission.levels.last.id)
        else
          exclude_ids = completed_ids(mission)

          if exclude_ids.any?
            level = mission.levels.scoped(:conditions => ["id NOT IN(?)", exclude_ids]).first
          else
            level = mission.levels.first
          end

          proxy_owner.mission_level_ranks.build(:level => level, :mission => mission)
        end
      end

      def completed_ids(mission)
        proxy_owner.mission_level_ranks.all(
          :select     => "level_id",
          :conditions => {
            :completed  => true,
            :mission_id => mission.id
          }
        ).collect{|m| m.level_id }
      end
    end

    module MissionAssociationExtension
      def fulfill!(mission)
        MissionResult.create(proxy_owner, mission)
      end

      def check_completion!(mission)
        rank = rank_for(mission)

        rank.save! if rank.completed?

        rank
      end

      def completed?(mission)
        completed_ids(mission.mission_group).include?(mission.id)
      end

      def completed_ids(group)
        proxy_owner.mission_ranks.all(
          :select     => "mission_id",
          :conditions => {
            :completed        => true,
            :mission_group_id => group.id
          }
        ).collect{|m| m.mission_id }
      end

      def rank_for(mission)
        proxy_owner.mission_ranks.find_or_initialize_by_mission_id(mission.id)
      end
    end

    module MissionGroupAssociationExtension
      def current(group_id = nil)
        groups = MissionGroup.with_state(:visible)

        group = groups.find_by_id(group_id) if group_id
        group ||= groups.find_by_id(proxy_owner.current_mission_group_id) if proxy_owner.current_mission_group_id
        group ||= groups.first

        proxy_owner.update_attribute(:current_mission_group_id, group.id) if group.id != proxy_owner.current_mission_group_id

        group
      end

      def check_completion!(group)
        rank = rank_for(group)

        rank.save! if rank.completed?

        rank
      end

      def rank_for(group)
        # Rank instance is created from class except of association to avoid rank creation when saving character
        proxy_owner.mission_group_ranks.find_by_mission_group_id(group.id) ||
          MissionGroupRank.new(
            :character      => proxy_owner,
            :mission_group  => group
          )
      end
    end
    
    module MissionHelpAssociationExtension
      def uncollected
        scoped(:conditions => {:collected => false}, :order => "mission_help_results.created_at DESC")
      end
      
      def collect_reward!
        basic_money = uncollected.sum(:basic_money)
        experience  = uncollected.sum(:experience)
        
        transaction do
          proxy_owner.charge(- basic_money, 0)
          proxy_owner.experience += experience
          
          proxy_owner.save!
          
          uncollected.update_all(:collected => true)
        end
        
        [basic_money, experience]
      end
    end
  end
end
