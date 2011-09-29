class ExtendingMissionTexts < ActiveRecord::Migration
  def self.up
    change_column :missions, :description, :text
    change_column :missions, :success_text, :text
    change_column :missions, :failure_text, :text
    change_column :missions, :complete_text, :text
  end

  def self.down
    change_column :missions, :description, :string
    change_column :missions, :success_text, :string
    change_column :missions, :failure_text, :string
    change_column :missions, :complete_text, :string
  end
end
