class ElementInteraction < ActiveRecord::Base
  validates_presence_of :attack_element, :defence_element, :factor

  after_create :create_opposite_interaction

  def validate
    if attack_element == defence_element
      errors.add(:defence_element, "Element should be different") 
    end
  end

  def create_opposite_interaction
    opposite_interaction = ElementInteraction.find(:first,
      :conditions => ["attack_element = ? AND defence_element = ?", self.defence_element, self.attack_element])
    unless opposite_interaction
      opposite_interaction = ElementInteraction.new(:attack_element => defence_element,
                                                    :defence_element => attack_element,
                                                    :factor => factor)
      opposite_interaction.save
    end
  end
end
