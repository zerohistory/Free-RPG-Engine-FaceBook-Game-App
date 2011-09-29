class Relation < ActiveRecord::Base
  ATTRIBUTES = %w{level attack defence health energy stamina}

  belongs_to  :owner, :class_name => "Character"
  belongs_to  :character
  has_one     :assignment, :dependent => :destroy, :foreign_key => "relation_id"

  named_scope :not_assigned,
    :include    => [:assignment, :character],
    :conditions => "assignments.id IS NULL"
  named_scope :assigned,
    :include    => [:assignment, :character],
    :conditions => "assignments.id IS NOT NULL"

  #TODO Check size of the 'bag' placement when relation is getting removed

  after_create  :increment_owner_relations_counter
  after_destroy :decrement_owner_relations_counter

  protected

  def increment_owner_relations_counter
    Character.update_counters_without_lock(owner_id, :relations_count => 1)
  end

  def decrement_owner_relations_counter
    Character.update_counters_without_lock(owner_id, :relations_count => -1)
  end
end
