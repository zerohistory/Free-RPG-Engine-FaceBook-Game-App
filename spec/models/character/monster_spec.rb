require "spec_helper"

describe Character do
  describe 'when fetching monster types available for fight' do
    before do
      @monster_type1 = Factory(:monster_type)
      @monster_type2 = Factory(:monster_type, :level => 2)
      @monster_type3 = Factory(:monster_type, :level => 3)

      @character = Factory(:character, :level => 2)
    end
    
    it 'should fetch all monsters with level lower than character\'s level' do
      @character.monster_types.available_for_fight.should include(@monster_type1, @monster_type2)
      @character.monster_types.available_for_fight.should_not include(@monster_type3)
    end

    it 'should exclude monsters which are currently active' do
      Monster.create!(:character => @character, :monster_type => @monster_type1)

      @character.monster_types.available_for_fight.should_not include(@monster_type1)
    end
  end
end