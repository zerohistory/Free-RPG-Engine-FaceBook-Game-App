class AddReferenceToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :reference
      
      t.index :reference
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :reference
    end
  end
end
