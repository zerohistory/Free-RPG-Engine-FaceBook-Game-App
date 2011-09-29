class UpdateRatingLabels < ActiveRecord::Migration
  def self.up
    %{level total_money fights missions relations}.each do |key|
      Translation.update_all "translations.key='ratings.#{key}.title'", "translations.key='ratings.show.#{key}'"
    end
  end

  def self.down
  end
end
