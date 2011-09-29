class Fight < ActiveRecord::Base
  belongs_to :attacker, :class_name => "Character", :extend => Fight::UsedItems
  belongs_to :victim, :class_name => "Character", :extend => Fight::UsedItems
  belongs_to :winner, :class_name => "Character"

  belongs_to  :cause, :polymorphic => true

  has_many :losses
  has_many :items, :through => :losses

  has_many :property_losses
  has_many :property_types, :through => :property_losses

  named_scope :with_participant, Proc.new {|character|
    {
      :conditions => ["attacker_id = :id OR victim_id = :id", {:id => character.id}],
      :order => "created_at DESC",
      :include => [:attacker, :victim]
    }
  }

  before_create :calculate_fight
  after_create  :save_payout, :post_to_newsfeed

  cattr_accessor :fighting_system, :damage_system
  @@fighting_system = FightingSystem::PlayerVsPlayer::Proportion
  @@damage_system = FightingSystem::DamageCalculation::Proportion

  attr_reader :attacker_boost, :victim_boost, :payouts

  def attacker_won?
    self.winner == attacker
  end

  def victim_won?
    self.winner == victim
  end

  def loser
    return nil unless winner

    (self.winner == attacker) ? victim : attacker
  end

  def is_response?
    not cause.nil?
  end

  def response
    self.class.first(:conditions => ["cause_id = ? AND cause_type = 'Fight'", id])
  end

  def responded?
    not response.nil?
  end

  def respondable?
    attacker_won? and not responded?
  end

  def enough_stamina?
    attacker.sp >= Setting.i(:fight_stamina_required)
  end

  def stamina_requirement
    Requirements::StaminaPoint.new(:value => Setting.i(:fight_stamina_required))
  end

  def found_losses
    losses.collect do |loss|
      loss.item.can_be_found? ? loss : nil
    end.compact
  end

  def found_properties
    property_losses.collect do |loss|
      loss.property_type.can_be_found? ? loss : nil
    end.compact
  end

  def attacker_boost
    if defined?(@attacker_boost)
      @attacker_boost
    else
      @attacker_boost = @attacker_boost_id ? Boost.find(@attacker_boost_id) : nil
    end
  end

  def victim_boost
    if defined?(@victim_boost)
      @victim_boost
    else
      @victim_boost = @victim_boost_id ? Boost.find(@victim_boost_id) : nil
    end
  end

  protected

  def validate
    if !enough_stamina?
      errors.add(:character, :not_enough_stamina)
    elsif attacker.weak?
      errors.add(:character, :too_weak)
    elsif !Setting.b(:fight_weak_opponents) && victim.weak?
      errors.add(:victim, :too_weak)
    elsif !Setting.b(:fight_alliance_attack) && attacker.friend_relations.established?(victim)
      errors.add(:character, :cannot_attack_friends)
    elsif (is_response? && cause.is_a?(Fight) && !cause.respondable?) || (!is_response? && !attacker.can_attack?(victim))
      errors.add(:character, :cannot_attack)
    elsif attacker == victim
      errors.add(:character, :cannot_attack_self)
    end
  end

  def calculate_fight
    won = self.class.fighting_system.calculate(attacker, victim)

    victim_damage, attacker_damage = self.class.damage_system.calculate(attacker, victim, won)

    self.winner = won ? attacker : victim

    self.victim_hp_loss = victim_damage
    self.attacker_hp_loss = attacker_damage

    self.experience = Setting.p(:fight_experience, rand(loser.level)).floor
    self.experience = 1 if experience == 0

    self.winner_money = winner_reward
    self.loser_money  = (loser.basic_money >= winner_money ? winner_money : loser.basic_money)

    @attacker_boost = attacker.boosts.best_attacking
    @victim_boost = victim.boosts.best_defending
  end

  def winner_reward
    if loser.basic_money > 0
      fight_money_bonus = 0.01 * winner.assignments.fight_income_effect

      [
        (rand(loser.basic_money) * (Setting.i(:fight_money_loot) * 0.01 + fight_money_bonus)).floor,
        Setting.i(:fight_max_money)
      ].min
    else
      (Setting.i(:fight_min_money) + Setting.f(:fight_min_money_per_level) * loser.level).round
    end
  end

  def save_payout
    winner.experience += experience

    winner.charge(- winner_money, 0, :fight_win)
    loser.charge(loser_money, 0, :fight_lose)

    attacker.sp  -= Setting.i(:fight_stamina_required)

    attacker.hp  -= attacker_hp_loss
    victim.hp    -= victim_hp_loss

    if loser.hp == 0
      # player lose equipped items
      self.losses = loser.lose_equipped_items(self)
      winner.find_lost_items(self.losses)

      self.property_losses = loser.lose_properties(self)
      winner.find_lost_properties(self.property_losses)
    end
    
    attacker.inventories.take!(@attacker_boost.item) if @attacker_boost
    victim.inventories.take!(@victim_boost.item) if @victim_boost
    
    if global_payout = GlobalPayout.by_alias(:fights)
      @payouts = global_payout.payouts.apply(attacker, attacker == winner ? :success : :failure)
    end

    winner.fights_won += 1
    loser.fights_lost += 1

    attacker.save!
    victim.save!
  end

  def post_to_newsfeed
    attacker.news.add(:fight_result, :fight_id => id)
    victim.news.add(:fight_result, :fight_id => id)
  end
end
