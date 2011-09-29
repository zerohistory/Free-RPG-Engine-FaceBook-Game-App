class CreateMissions < ActiveRecord::Migration
  def self.up
    create_table :missions do |t|
      t.integer :level
      
      t.string  :name
      t.string  :description

      t.string  :success_text
      t.string  :failure_text
      t.string  :complete_text

      t.integer :win_amount
      t.integer :success_chance, :default => 100

      t.string  :title

      t.integer :ep_cost

      t.integer :experience

      t.integer :money_min
      t.integer :money_max

      t.timestamps
    end
  end

  def self.down
    drop_table :missions
  end
end
