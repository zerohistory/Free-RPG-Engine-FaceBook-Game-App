class AddHospitalUsedAtToCharacters < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.datetime :hospital_used_at, :default => Time.at(0)
    end
  end

  def self.down
    change_table :characters do |t|
      t.remove :hospital_used_at
    end
  end
end
