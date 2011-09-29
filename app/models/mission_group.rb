class MissionGroup < ActiveRecord::Base
  extend HasPayouts
  extend HasRequirements

  has_many :missions,
    :order      => "missions.position",
    :dependent  => :destroy
  has_many :bosses, :dependent => :destroy
  has_many :ranks, :class_name => "MissionGroupRank", :dependent => :delete_all

  acts_as_list

  default_scope :order => "mission_groups.position"

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

    after_transition :to => :deleted do |group|
      group.delete_children!
    end
  end

  has_attached_file :image,
    :removable => true

  has_requirements
  has_payouts(Mission.payout_events + [:mission_group_complete],
    :apply_on => :mission_group_complete
  )

  validates_presence_of :name

  def self.to_dropdown(*args)
    without_state(:deleted).all(:order => :position).to_dropdown(*(args.any? ? args : :name))
  end

  def delete_children!
    missions.without_state(:deleted).all.map{|m| m.mark_deleted }
    bosses.without_state(:deleted).all.map{|b| b.mark_deleted }
  end
  
  def applicable_payouts
    if global_payout = GlobalPayout.by_alias('missions')
      payouts + global_payout.payouts
    else
      payouts
    end
  end
end
