require 'factory_girl'

Factory.define :user do |t|
  t.facebook_id 123456789
  
  t.access_token 'abc123'
  t.access_token_expire_at 1.day.from_now
end

Factory.define :user_with_character, :parent => :user do |t|
  t.after_create do |u|
    Factory(:character, :user => u)
  end
end

Factory.define :user_with_email, :parent => :user do |t|
  t.email "test@test.com"
end

Factory.define :character_type do |t|
  t.name "Character Type"
  t.description "This is our test character type"

  t.basic_money 0
  t.vip_money   1

  t.attack      1
  t.defence     1
  
  t.health      100
  t.energy      10
  t.stamina     10

  t.points      0
end

Factory.define :character do |t|
  t.name "Character"
  
  t.association :user
  t.association :character_type
end

Factory.define :property_type do |t|
  t.name        "Property Type"
  t.plural_name "Property Types"
  t.description "This our test property type"

  t.image_file_name     "property.jpg"
  t.image_content_type  "image/jpeg"
  t.image_file_size     100.kilobytes

  t.availability "shop"

  t.level 1

  t.basic_price 1000
  t.vip_price   1

  t.upgrade_cost_increase 100

  t.income 10

  t.state "visible"
end

Factory.define :property do |t|
  t.association :character
  t.association :property_type, :factory => :property_type
end

Factory.define :visibility do |t|
  t.association :target, :factory => :item
  t.association :character_type
end

Factory.define :item_group do |t|
  t.name            'first'
end

Factory.define :item do |t|
  t.association   :item_group

  t.name          'Fake Item'
  t.availability  'shop'
  t.level         1

  t.basic_price   10

  t.usable  true
  t.payouts Payouts::Collection.new(
    Payouts::BasicMoney.new(:value => 100, :apply_on => :use)
  )

  t.placements [:left_hand, :additional]
end

Factory.define :inventory do |t|
  t.association :character
  t.association :item
  
  t.amount 5
end

Factory.define :market_item do |t|
  t.association :inventory
  
  t.amount 1
end

Factory.define :item_collection do |t|
  t.name 'Fake Collection'
  t.item_ids {|c|
    (1..3).collect{ Factory(:item).id }
  }
end

Factory.define :hit_listing do |t|
  t.client {|c| 
    c.association :character, Factory.attributes_for(:character).merge(:basic_money => 10_000)
  }
  t.victim {|v|
    v.association :character
  }

  t.reward 10_000
end

Factory.define :monster_type do |t|
  t.name 'The Monster'
  t.description 'The fake monster'

  t.requirements Requirements::Collection.new(
    Requirements::Level.new(:value => 1)
  )

  t.payouts Payouts::Collection.new(
    Payouts::BasicMoney.new(:value => 123, :apply_on => :victory),
    Payouts::BasicMoney.new(:value => 456, :apply_on => :repeat_victory)
  )

  t.attack 10
  t.defence 10

  t.minimum_damage 3
  t.maximum_damage 10
  t.minimum_response 1
  t.maximum_response 5

  t.experience 5
  t.money 5

  t.health 1000

  t.state 'visible'
end

Factory.define :monster do |t|
  t.association :monster_type
  t.association :character
end

Factory.define :monster_fight do |t|
  t.association :monster
  t.association :character

  t.damage 1
end

Factory.define :mission_group do |t|
  t.name "Some Group"

  t.state 'visible'
end

Factory.define :mission_level do |t|
  t.association :mission
  
  t.win_amount 5
  t.energy 5
  t.experience 5
  t.money_min 10
  t.money_max 20
  t.chance 50
end

Factory.define :mission do |t|
  t.association :mission_group

  t.name "Some Mission"
  t.success_text "Success!"
  t.complete_text "Complete!"

  t.state 'visible'
end

Factory.define :mission_with_level, :parent => :mission do |t|
  t.after_create do |m|
    m.levels << Factory(:mission_level, :mission => m)
  end
end

Factory.define :item_set do |t|
  t.name 'Fake Item Set'
  t.item_ids do
    item1 = Factory(:item)
    item2 = Factory(:item)

    "[[#{item1.id}, 70], [#{item2.id}, 30]]"
  end
end

Factory.define :boss do |t|
  t.association :mission_group

  t.name 'Fake Boss'
  t.health 100
  t.attack 1
  t.defence 1
  t.ep_cost 5
  t.experience 10
  
  t.state 'visible'
end

Factory.define :wall_post do |t|
  t.association :character
  t.association :author, :factory => :character

  t.text "This is a Fake Text"
end

Factory.define :promotion do |t|
  t.text 'This is fake promotion'
  
  t.valid_till 1.day.from_now
end

Factory.define :story do |t|
  t.alias 'level_up'
  
  t.title 'This is the fake story'
  t.description 'This is description'
  t.action_link 'Play our app!'
end

Factory.define :mission_help_result do |t|
  t.association :mission, :factory => :mission_with_level

  t.association :character
  t.association :requester, :factory => :character
end

Factory.define :app_request_base, :class => 'AppRequest::Base' do |t|
  t.facebook_id 123456789
  t.state 'processed'
end

Factory.define :app_request_gift, :class => 'AppRequest::Gift' do |t|
  t.facebook_id 123456789
  t.receiver_id 123456789
  t.sender {|g| 
    g.association(:user_with_character, :facebook_id => 111222333).character
  }
  t.data { 
    {'item_id' => Factory(:item).id} 
  }
  t.state 'processed'
end

Factory.define :app_request_monster_invite, :class => 'AppRequest::MonsterInvite' do |t|
  t.facebook_id 123456789
  t.receiver_id 123456789
  t.sender {|g| 
    g.association(:user_with_character, :facebook_id => 111222333).character
  }
  t.data { 
    {'monster_id' => Factory(:monster).id} 
  }
  t.state 'processed'
end

Factory.define :app_request_invitation, :class => 'AppRequest::Invitation' do |t|
  t.facebook_id 123456789
  t.receiver_id 123456789
  t.sender {|g| 
    g.association(:user_with_character, :facebook_id => 111222333).character
  }
  t.state 'processed'
end

Factory.define :global_payout do |t|
  t.name 'Fake Payout'
  t.alias 'fake_payout'
  
  t.payouts Payouts::Collection.new(
    Payouts::BasicMoney.new(:value => 123, :apply_on => :success)
  )
end
