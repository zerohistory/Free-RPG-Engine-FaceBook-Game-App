require 'spec_helper'

describe Visibility do
  it 'should valitate uniqueness' do
    item = Factory.create(:item)
    character_type = Factory.create(:character_type)

    Factory.create(:visibility,
      :target => item,
      :character_type => character_type
    )

    new_visibility = Factory.build(:visibility,
      :target => item,
      :character_type => character_type
    )
    
    new_visibility.should_not be_valid
  end
end
