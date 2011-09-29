class Assignment < ActiveRecord::Base
  ROLES = %w{attack defence fight_damage fight_income mission_energy mission_income}

  belongs_to :context, :polymorphic => true
  belongs_to :relation

  validates_presence_of :context_id, :context_type, :relation_id

  def validate
    # the only one role may have 2+ assignments
    character = Character.find(self.relation.character_id)
#    unless character.assignments.can_promote?(self.role)
#      errors.add(:role, "Only one role may have 2+ assignments")
#    end
  end

  before_create :destroy_current_assignments

  before_save :store_owner_attributes_on_save
  after_save :update_owner_attributes_on_save

  before_destroy :store_owner_attributes_on_destroy
  after_destroy :update_owner_attibutes_on_destroy

  class << self
    ROLES.each do |role|
      class_eval %[
        def #{role}_effect
          by_role('#{role}').try(:effect_value) || 0
        end
      ]
    end
    
    def by_role(role)
      all.detect{|a| a.role == role.to_s }
    end

    def effect_value(context, relation, role)
      case role.to_sym
      when :attack
        Setting.p(:assignment_attack_bonus, relation.character.attack_points).floor
      when :defence
        Setting.p(:assignment_defence_bonus, relation.character.defence_points).floor
      when :fight_damage
        Setting.p(:assignment_health_bonus, relation.character.health_points).floor
      when :fight_income
        Setting.p(:assignment_stamina_bonus, relation.character.stamina_points).floor
      when :mission_energy
        Setting.p(:assignment_energy_bonus, relation.character.level).floor
      when :mission_income
        Setting.p(:assignment_mission_income_bonus, relation.character.energy_points).floor
      end
    end

    def log_percent(parameter, multiplier, divider)
      chance = multiplier * Math.log(parameter.to_f / divider)

      chance <= 0 ? 1 : chance.floor
    end
  end

  def effect_value
    self.class.effect_value(context, relation, role)
  end

  protected

  def destroy_current_assignments
    self.class.find_all_by_relation_id(relation_id).each do |assignment|
      assignment.destroy
    end

    true
  end

  def store_owner_attributes_on_save
    owner = self.relation.owner
    case self.role
    when "fight_damage"   then @stored_owner_attribute = {:value => owner.hp, :apply => owner.sp == owner.health_points}
    when "fight_income"   then @stored_owner_attribute = {:value => owner.sp, :apply => owner.sp == owner.stamina_points}
    when "mission_energy" then @stored_owner_attribute = {:value => owner.ep, :apply => owner.ep == owner.energy_points}
    end
  end

  def update_owner_attributes_on_save
    if @stored_owner_attribute[:apply]
      case self.role
        when "fight_damage"   then self.relation.owner.hp = @stored_owner_attribute[:value]
        when "fight_income"   then self.relation.owner.sp = @stored_owner_attribute[:value]
        when "mission_energy" then self.relation.owner.ep = @stored_owner_attribute[:value]
      end
    end
  end

  def store_owner_attributes_on_destroy
    owner = self.relation.owner

    case self.role
    when "fight_damage" then @stored_owner_attribute = {:value => owner.hp}
    when "fight_income" then @stored_owner_attribute = {:value => owner.sp}
    when "mission_energy" then @stored_owner_attribute = {:value => owner.ep}
    end
  end

  def update_owner_attibutes_on_destroy
    owner = self.relation.owner

    case self.role
    when "fight_damage" then owner.hp = @stored_owner_attribute[:value] if @stored_owner_attribute[:value] == owner.health_points
    when "fight_income" then owner.sp = @stored_owner_attribute[:value] if @stored_owner_attribute[:value] == owner.stamina_points
    when "mission_energy" then owner.ep = @stored_owner_attribute[:value] if @stored_owner_attribute[:value] == owner.energy_points
    end
  end
end
