class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.string  :type, :limit => 100
      t.integer :character_id
      t.text    :data
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
