puts "Seeding assets..."

asset_folder = File.join(RAILS_ROOT, "public", "images")

Dir[File.join(asset_folder, "**", "*")].each do |file_name|
  if File.file?(file_name)
    Asset.create(
      :alias => file_name.sub(asset_folder + "/", "").sub(File.extname(file_name), "").gsub("/", "_"),
      :image => File.open(file_name)
    )
  end
end
