class CreateTips < ActiveRecord::Migration
  def self.up
    add_column :users, :show_tips, :boolean, :default => true

    create_table :tips do |t|
      t.text :text
      
      t.timestamps
    end
  end

  def self.down
    remove_column :users, :show_tips

    drop_table :tips
  end
end
