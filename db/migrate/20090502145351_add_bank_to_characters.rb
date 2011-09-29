class AddBankToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :bank, :integer, :default => 0

    create_table :bank_operations do |t|
      t.integer :character_id

      t.integer :amount

      t.string  :type

      t.timestamps
    end
  end

  def self.down
    drop_table :bank_operations
    
    remove_column :characters, :bank
  end
end
