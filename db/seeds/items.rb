puts "Seeding items..."

weapons = ItemGroup.create!(:name => "Weapons")

weapons.items.create!(
  :name         => "Knife",
  :level        => 1,
  :basic_price  => 40,
  :attack       => 1,
  :placements   => [:left_hand, :right_hand, :additional],
  :can_be_sold_on_market => true,
  :image        => File.open(Rails.root.join("db", "pictures", "knife.jpg"))
)

weapons.items.create!(
  :name         => "Dagger",
  :availability => "gift",
  :level        => 1,
  :basic_price  => 40,
  :attack       => 1,
  :placements   => [:left_hand, :right_hand, :additional],
  :can_be_sold  => false,
  :image        => File.open(Rails.root.join("db", "pictures", "dagger.jpg"))
)

armors = ItemGroup.create!(:name => "Armors")

armors.items.create!(
  :name         => "Wooden Shield",
  :level        => 1,
  :basic_price  => 70,
  :defence      => 1,
  :placements   => [:left_hand, :right_hand, :additional],
  :image        => File.open(Rails.root.join("db", "pictures", "shield.jpg"))
)

potions = ItemGroup.create!(:name => "Potions")

potions.items.create!(
  :name         => "Potion of Healing",
  :level        => 2,
  :basic_price  => 100,
  :usable       => true,
  :image        => File.open(Rails.root.join("db", "pictures", "potion_of_healing.jpg")),
  :payouts      => Payouts::Collection.new(
    Payouts::HealthPoint.new(:value => 50, :apply_on => :use, :visible => true)
  )
)

potions.items.create!(
  :name         => "Potion of Upgrade",
  :level        => 2,
  :basic_price  => 50,
  :vip_price    => 5,
  :usable       => true,
  :image        => File.open(Rails.root.join("db", "pictures", "potion_of_upgrade.jpg")),
  :payouts      => Payouts::Collection.new(
    Payouts::UpgradePoint.new(:value => 5, :apply_on => :use, :visible => true)
  )
)
