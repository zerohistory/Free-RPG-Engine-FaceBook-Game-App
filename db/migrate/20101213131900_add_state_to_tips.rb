class AddStateToTips < ActiveRecord::Migration
  def self.up
    change_table :tips do |t|
      t.string :state, :limit => 50
    end

    Tip.update_all "state = 'visible'"
  end

  def self.down
    change_table :tips do |t|
      t.remove :state
    end
  end
end
