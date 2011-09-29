class MakeIpFieldsUnsigned < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :last_visit_ip,  :bigint
      t.change :signup_ip,      :bigint
    end
  end

  def self.down
    change_table :users do |t|
      t.change :last_visit_ip,  :integer
      t.change :signup_ip,      :integer
    end
  end
end
