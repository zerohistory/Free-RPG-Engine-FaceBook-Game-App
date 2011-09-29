require 'spec_helper'

describe MonsterType do
  describe 'associations' do
    it 'should have many monsters' do
      should have_many :monsters
    end
  end

  describe 'default values' do
    before do
      @monster_type = MonsterType.new
    end

    it 'should be level 1 by default' do
      @monster_type.level.should == 1
    end

    it 'should have 12 hours for fight' do
      @monster_type.fight_time.should == 12
    end
  end

  describe 'when creating' do
    before do
      @monster_type = Factory.build(:monster_type)
    end

    %w{name level health attack defence experience money fight_time minimum_damage maximum_damage minimum_response maximum_response}.each do |attribute|
      it "should validate presence of #{attribute}" do
        @monster_type.should validate_presence_of(attribute)
      end
    end

    %w{level attack defence experience money fight_time minimum_damage maximum_damage minimum_response maximum_response}.each do |attribute|
      it "should validate numericality of #{attribute}" do
        @monster_type.should validate_numericality_of(attribute)
      end

      it "should validate that #{attribute} is greater than 0" do
        @monster_type.send("#{attribute}=", 0)

        @monster_type.should_not be_valid
        @monster_type.errors.on(attribute).should include('must be greater than 0')
      end
    end
  end
end