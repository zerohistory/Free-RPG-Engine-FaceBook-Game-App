class CreateSkins < ActiveRecord::Migration
  def self.up
    create_table :skins do |t|
      t.string  :name
      t.text    :content

      t.string  :state
      
      t.timestamps
    end
  end

  def self.down
    drop_table :skins
  end
end
