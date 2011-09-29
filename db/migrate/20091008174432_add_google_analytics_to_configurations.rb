class AddGoogleAnalyticsToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :app_google_analytics_id, :string
  end

  def self.down
    remove_column :configurations, :app_google_analytics_id
  end
end
