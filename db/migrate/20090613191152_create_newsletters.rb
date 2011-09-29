class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.string   :text
      t.string   :workflow_state,    :limit => 20
      t.integer  :last_recipient_id
      t.integer  :delivery_job_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :newsletters
  end
end
