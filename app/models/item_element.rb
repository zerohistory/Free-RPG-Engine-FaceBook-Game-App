class ItemElement < ActiveRecord::Base
  TYPE = ["Attack", "Defence"]

  belongs_to :items
  belongs_to :elements

  validates_presence_of :item_id, :element_id, :count, :effect_type
  validates_numericality_of :count, :effect_type

  named_scope :attack, :conditions => {:effect_type => 0}
  named_scope :defence, :conditions => {:effect_type => 1}

  def validate
    similar = ItemElement.find(:first,
                :conditions => ["item_id = ? AND element_id = ? AND effect_type = ?", item_id, element_id, effect_type])
    if similar
      errors.add(:element_id, "Element can not be used twice")
    end
  end
end
