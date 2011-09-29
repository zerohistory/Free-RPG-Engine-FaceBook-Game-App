class Visibility < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  belongs_to :character_type

  validates_uniqueness_of :character_type_id, :scope => [:target_id, :target_type]
end

