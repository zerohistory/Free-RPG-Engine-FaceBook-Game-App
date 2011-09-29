class AddPackagesToItems < ActiveRecord::Migration
  def self.up
    change_table :items do |t|
      t.integer :package_size
    end
  end

  def self.down
    change_table :items do |t|
      t.remove :package_size
    end
  end
end
