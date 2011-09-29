require 'spec_helper'

describe MissionGroupRank do
  describe 'when checking if mission group is completed' do
    before do
      @group = Factory(:mission_group)

      @mission1 = Factory(:mission_with_level, :mission_group => @group)
      @mission2 = Factory(:mission_with_level, :mission_group => @group)

      @boss1 = Factory(:boss, :mission_group => @group)

      @other_group = Factory(:mission_group)

      @mission3 = Factory(:mission_with_level, :mission_group => @other_group)

      @boss2 = Factory(:boss, :mission_group => @other_group)

      @character = Factory(:character)

      @rank = MissionGroupRank.new(
        :character => @character,
        :mission_group => @group
      )
    end

    def complete_mission!(mission)
      MissionLevelRank.create(
        :level      => mission.levels.first,
        :character  => @character,
        :progress   => mission.levels.first.win_amount
      )
      @character.missions.check_completion!(mission)
    end

    def complete_boss!(boss)
      fight = BossFight.create(
        :boss      => boss,
        :character  => @character
      )
      fight.win
    end

    it 'should return true if cached to attribute' do
      MissionGroupRank.create!(
        :character => @character,
        :mission_group => @group
      )

      MissionGroupRank.update_all :completed => true

      MissionGroupRank.first.should be_completed
    end

    it 'should return true if group missions and bosses are completed' do
      complete_mission!(@mission1)
      complete_mission!(@mission2)
      complete_boss!(@boss1)

      @rank.should be_completed
    end

    it 'should return false if group missions are not completed' do
      complete_mission!(@mission1)
      complete_boss!(@boss1)

      @rank.should_not be_completed
    end

    it 'should return false if group bosses are not defeated' do
      complete_mission!(@mission1)
      complete_mission!(@mission2)

      @rank.should_not be_completed
    end

    it 'should return false when having defeated bosses in other groups' do
      complete_mission!(@mission1)
      complete_mission!(@mission2)

      complete_boss!(@boss2)

      @rank.should_not be_completed
    end

    it 'should return false when having completed missions in other groups' do
      complete_mission!(@mission1)
      complete_mission!(@mission3)

      complete_boss!(@boss1)

      @rank.should_not be_completed
    end
  end
end