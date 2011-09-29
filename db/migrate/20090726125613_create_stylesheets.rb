class CreateStylesheets < ActiveRecord::Migration
  def self.up
    create_table :stylesheets do |t|
      t.string  :name
      t.text    :content

      t.boolean :current

      t.timestamps
    end
  end

  def self.down
    drop_table :stylesheets
  end
end
