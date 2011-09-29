class AddSocialDataToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string  :first_name,  :limit => 50, :null => false, :default => ''
      t.string  :last_name,   :limit => 50, :null => false, :default => ''
      t.integer :gender
      t.integer :timezone
      t.string  :locale,      :limit => 5,  :null => false, :default => 'en_US'
    end
  end

  def self.down
    change_table :users do |t|
      t.remove  :first_name
      t.remove  :last_name
      t.remove  :gender
      t.remove  :timezone
      t.remove  :locale
    end
  end
end
