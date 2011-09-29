class AddStateToAppRequests < ActiveRecord::Migration
  def self.up
    change_table :app_requests do |t|
      t.string :state, :limit => 50, :default => "", :null => false
      
      t.datetime :processed_at
      t.datetime :accepted_at
    end
    
    ActiveRecord::Base.connection.execute "UPDATE app_requests SET state = 'processed'"
  end

  def self.down
    change_table :app_requests do |t|
      t.remove :state
      t.remove :processed_at
      t.remove :accepted_at
    end
  end
end
