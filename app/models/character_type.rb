class CharacterType < ActiveRecord::Base
  APPLICABLE_ATTRIBUTES = %w{attack defence health energy stamina basic_money vip_money points}
  BONUSES = %w{health_restore_bonus energy_restore_bonus stamina_restore_bonus income_period_bonus}

  has_many :characters

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
  end

  has_attached_file :image,
    :styles => {
      :icon   => "40x40#",
      :small  => "120x120>",
      :stream => "90x90#"
    },
    :removable => true

  validates_presence_of [:name] + APPLICABLE_ATTRIBUTES + BONUSES
  validates_numericality_of APPLICABLE_ATTRIBUTES + BONUSES,
    :allow_nil => true
end
