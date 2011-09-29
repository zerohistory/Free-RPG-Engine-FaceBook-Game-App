class NullifyDefaultCharacterAttributes < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      %w{basic_money vip_money attack defence health energy stamina points}.each do |attribute|
        t.change attribute, :integer, :default => nil
      end
    end
  end

  def self.down
    change_table :characters do |t|
      t.change :basic_money,  :integer, :default => 10
      t.change :vip_money,    :integer, :default => 0
      t.change :attack,       :integer, :default => 1
      t.change :defence,      :integer, :default => 1
      t.change :health,       :integer, :default => 100
      t.change :energy,       :integer, :default => 10
      t.change :stamina,      :integer, :default => 10
      t.change :points,       :integer, :default => 0
    end
  end
end
