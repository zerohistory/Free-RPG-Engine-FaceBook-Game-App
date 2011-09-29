class RemoveStylesheets < ActiveRecord::Migration
  def self.up
    drop_table :stylesheets
  end

  def self.down
    create_table "stylesheets", :force => true do |t|
      t.string   "name"
      t.text     "content"
      t.boolean  "current"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
