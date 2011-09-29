class Monster < ActiveRecord::Base
  belongs_to  :monster_type
  belongs_to  :character
  has_many    :monster_fights

  named_scope :current, Proc.new{
    {
      :conditions => ["(defeated_at IS NULL AND expire_at >= :time) OR (defeated_at >= :time)",
        {:time => Setting.i(:monsters_reward_time).hours.ago}
      ]
    }
  }
  named_scope :by_type, Proc.new{|type|
    {
      :conditions => {:monster_type_id => type.id}
    }
  }

  state_machine :initial => :progress do
    state :progress
    state :won
    state :expired

    event :win do
      transition :progress => :won
    end

    event :expire do
      transition :progress => :expired
    end
  end

  delegate :name, :image, :image?, :health, :level, :experience, :money, :requirements, :attack, :defence,
    :minimum_damage, :maximum_damage, :minimum_response, :maximum_response, :to => :monster_type

  attr_reader :payouts

  validates_presence_of :character, :monster_type

  before_create :assign_initial_attributes, :apply_fight_start_payouts
  after_create  :create_fight

  before_update :check_negative_health_points
  after_update  :check_winning_status

  def time_remaining
    (expire_at - Time.now).to_i
  end

  protected

  def assign_initial_attributes
    self.hp = health

    self.expire_at = monster_type.fight_time.hours.from_now
  end

  def apply_fight_start_payouts
    @payouts = monster_type.payouts.apply(character, :fight_start, monster_type)
  end

  def validate_on_create
    return unless character && monster_type

    errors.add(:base, :recently_attacked) if character.monsters.current.by_type(monster_type).count > 0

    errors.add(:character, :low_level) if character.level < level

    errors.add(:character, :requirements_not_satisfied) unless requirements.satisfies?(character)
  end

  def create_fight
    monster_fights.create!(:character => character)
  end

  def check_negative_health_points
    self.hp = 0 if hp < 0
  end

  def check_winning_status
    win! if progress? and hp == 0
  end
end
