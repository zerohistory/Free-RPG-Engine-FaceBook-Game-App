require 'spec_helper'

describe MissionRank do
  describe 'when saving' do
    before do
      @character = Factory(:character)

      @mission = Factory(:mission)

      @level1 = Factory(:mission_level, :mission => @mission)
      @level2 = Factory(:mission_level, :mission => @mission)

      @mission_rank = MissionRank.new(:character => @character, :mission => @mission)
    end

    it 'should not become completed if some levels are not completed' do
      @character.mission_level_ranks.create(:level => @level1, :progress => 5)
      @character.mission_level_ranks.create(:level => @level2, :progress => 4)

      @mission_rank.save
      @mission_rank.reload.completed?.should_not be_true
    end
    
    it 'should become completed if all levels are completed' do
      @character.mission_level_ranks.create(:level => @level1, :progress => 5)
      @character.mission_level_ranks.create(:level => @level2, :progress => 5)

      @mission_rank.save
      @mission_rank.reload.completed?.should be_true
    end

    it 'should store mission group' do
      @mission_rank.save

      @mission_rank.reload.mission_group.should == @mission.mission_group
    end
  end
end