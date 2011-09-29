puts "Seeding tips..."

Tip.create!(
  :text => "Put your money to the <a href=\"/bank_operations/new\">Treasure</a> and no one will be able to grab it in the fight"
)

Tip.create!(
  :text => "Properties give you hourly income. Purchase <a href=\"/properties/new\">more properties</a> to get more money in the future."
)
