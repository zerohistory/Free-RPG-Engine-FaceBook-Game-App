class Element < ActiveRecord::Base
  validates_presence_of   :name
  validates_uniqueness_of :name

  has_many :item_elements
  has_many :elements, :through => :item_elements

  def self.to_empty_hash
    res = {}
    Element.all.each do |e|
      res[e.id] = 0
    end

    res
  end
end
