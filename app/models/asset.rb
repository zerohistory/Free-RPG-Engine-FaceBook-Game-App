class Asset < ActiveRecord::Base
  has_attached_file :image, :styles => {:small => "100x100>"}

  validates_presence_of :alias
  validates_uniqueness_of :alias
  validates_format_of :alias, :with => /^[a-z_0-9]+$/, :allow_blank => true

  class << self
    def [](value)
      logger.silence do
        find_by_alias(value.to_s)
      end
    end

    def sass_path
      Rails.root.join("public", "stylesheets", "sass", "_assets.sass")
    end

    def update_sass
      File.open(sass_path, "w+") do |file|
        all.each do |asset|
          file.puts "!asset_#{asset.alias.underscore} = url(\"#{asset.image.url}\")"
        end
      end
    end
  end
end
