class HitListing < ActiveRecord::Base
  belongs_to :client,   :class_name => "Character"
  belongs_to :victim,   :class_name => "Character"
  belongs_to :executor, :class_name => "Character"

  named_scope :incomplete,
    :conditions => {:completed => false},
    :include    => [:victim, :client]
  named_scope :completed_recently, Proc.new {
    {
      :conditions => ["completed = 1 AND updated_at > ?", Setting.i(:hit_listing_repeat_listing_delay).hours]
    }
  }
  named_scope :available_for, Proc.new{|character|
    exclude_ids = [character.id]
    exclude_ids.push(*character.friend_relations.character_ids) unless Setting.b(:fight_alliance_attack)

    {
      :conditions => ["victim_id NOT IN (?)", exclude_ids]
    }
  }


  validates_presence_of :client, :victim, :reward
  validates_numericality_of :reward,
    :greater_than_or_equal_to => Setting.i(:hit_list_minimum_reward),
    :allow_blank => true,
    :on => :create

  validate_on_create :check_victim_weakness, :check_victim_listed, :check_client_balance

  before_create :charge_client, :take_fee_from_reward

  def execute!(attacker)
    errors.add(:base, :already_completed) if completed?
    errors.add(:base, :client_attack) if attacker == client
    
    return false if errors.any?

    Fight.new(:attacker => attacker, :victim => victim, :cause => self).tap do |fight|
      transaction do
        if fight.save && victim.hp == 0
          self.executor   = attacker
          self.completed  = true

          attacker.charge!(- reward, 0, self)

          save!
        end
      end
    end
  end

  protected

  def check_victim_weakness
    if victim && victim.weak?
      errors.add(:victim, :too_weak)
    end
  end

  def check_victim_listed
    return unless victim
    
    errors.add(:victim, :already_listed) if self.class.incomplete.find_by_victim_id(victim.id)
    errors.add(:victim, :recently_listed) if self.class.completed_recently.find_by_victim_id(victim.id)
  end

  def check_client_balance
    if reward && client && client.basic_money < reward
      errors.add(:reward, :not_enough_basic_money, :basic_money => Character.human_attribute_name("basic_money"))
    end
  end

  def charge_client
    client.charge!(reward, 0, :hit_listing_posting)
  end

  def take_fee_from_reward
    self.reward -= Setting.p(:hit_list_reward_fee, reward)
  end
end
