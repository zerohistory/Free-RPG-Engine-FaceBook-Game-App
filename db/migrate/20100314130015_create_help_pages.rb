class CreateHelpPages < ActiveRecord::Migration
  def self.up
    create_table :help_pages do |t|
      t.string  :alias,             :limit => 100
      t.string  :name,              :limit => 100
      
      t.text    :content,           :limit => 4.kilobytes
      t.text    :content_processed, :limit => 5.kilobytes

      t.string  :state,             :limit => 30
      
      t.timestamps
    end
  end

  def self.down
    drop_table :help_pages
  end
end
