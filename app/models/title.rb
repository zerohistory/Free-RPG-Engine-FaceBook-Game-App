class Title < ActiveRecord::Base
  state_machine :initial => :visible do
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
  end

  class << self
    def to_dropdown
      with_state(:visible).all(:order => "name ASC").to_dropdown
    end
  end
end
