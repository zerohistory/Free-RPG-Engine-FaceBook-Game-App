class ItemGroup < ActiveRecord::Base
  has_many :items, :dependent => :destroy

  acts_as_list

  named_scope :visible_in_shop,
    :conditions => "display_in_shop = 1",
    :order      => "position"

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
      group.delete_items!
    end
  end

  validates_presence_of :name

  def self.to_dropdown(*args)
    without_state(:deleted).all(:order => :position).to_dropdown(*args)
  end

  def delete_items!
    items.without_state(:deleted).map{|i| i.mark_deleted }
  end
end
