class CreateGlobalPayouts < ActiveRecord::Migration
  def self.up
    create_table :global_payouts do |t|
      t.string  :name,  :limit => 100, :default => "", :null => false
      t.string  :alias, :limit => 70,  :default => "", :null => false
      t.text    :payouts
      t.string  :state, :limit => 50,  :default => "", :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :global_payouts
  end
end
