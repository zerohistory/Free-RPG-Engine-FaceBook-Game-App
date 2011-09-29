class Mission < ActiveRecord::Base
  extend HasPayouts
  extend HasRequirements
  include HasVisibility

  has_many    :levels, :class_name => "MissionLevel"
  has_many    :ranks, :class_name => "MissionRank", :dependent => :delete_all
  belongs_to  :mission_group
  belongs_to  :parent_mission, :class_name => "Mission"
  has_many    :child_missions, :class_name => "Mission", :foreign_key => "parent_mission_id", :dependent => :destroy

  acts_as_list :scope => 'mission_group_id = #{mission_group_id} AND missions.state != \'deleted\''

  state_machine :initial => :hidden do
    state :hidden
    state :visible
    state :deleted

    event :publish do
      transition :hidden => :visible
    end

    event :hide do
      transition :visible => :hidden
    end

    event :mark_deleted do
      transition(any - [:deleted] => :deleted)
    end
  end

  has_attached_file :image,
    :styles => {
      :icon   => "50x50>",
      :small  => "120x120>",
      :stream => "90x90#"
    },
    :removable => true

  has_requirements
  
  has_payouts(MissionLevel.payout_events + [:mission_complete],
    :apply_on => :mission_complete
  )

  validates_presence_of :mission_group, :name, :success_text, :complete_text
  
  after_update :update_group_in_ranks, :if => :mission_group_id_changed?

  def self.to_grouped_dropdown
    {}.tap do |result|
      MissionGroup.without_state(:deleted).each do |group|
        result[group.name] = group.missions.without_state(:deleted).collect{|i|
          [i.name, i.id]
        }
      end
    end
  end

  def visible_for?(character)
    parent_mission.nil? or character.missions.rank_for(parent_mission).completed?
  end
  
  def applicable_payouts
    payouts + mission_group.applicable_payouts
  end
  
  protected
  
  def update_group_in_ranks
    ranks.update_all :mission_group_id => mission_group_id
  end
end
