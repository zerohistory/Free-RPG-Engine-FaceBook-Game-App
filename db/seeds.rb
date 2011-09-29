ActiveRecord::Base.transaction do
  %w{settings assets items missions properties tips character_types}.each do |section|
    require File.expand_path("../seeds/#{section}", __FILE__)
  end
end

puts "Publishing seeded data..."

ActiveRecord::Base.transaction do
  [MissionGroup, Mission, ItemGroup, Item, Boss, PropertyType, CharacterType, Tip].each do |model|
    model.all.each do |record|
      record.publish
    end
  end
end

puts "Seed complete!"