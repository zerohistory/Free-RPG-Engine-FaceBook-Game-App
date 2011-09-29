require "spec_helper"

describe Character do
  describe "when receiving mission level rank" do
    before do
      @character = Factory(:character)

      @mission = Factory(:mission)

      @level1 = Factory(:mission_level, :mission => @mission)
      @level2 = Factory(:mission_level, :mission => @mission)
    end

    it 'should return first incomplete level rank' do
      @rank = @character.mission_level_ranks.create!(
        :level => @level1,
        :progress => 1
      )
      
      @character.mission_levels.rank_for(@mission).should == @rank
    end

    it 'should return rank for latest level when mission is completed' do
      @rank1 = @character.mission_level_ranks.create!(
        :level => @level1,
        :progress => 5
      )
      @rank2 = @character.mission_level_ranks.create!(
        :level => @level2,
        :progress => 5
      )

      @character.missions.check_completion!(@mission)

      @character.mission_levels.rank_for(@mission).should == @rank2
    end

    it 'should instantiate rank for the first incomplete mission level' do
      @rank1 = @character.mission_level_ranks.create!(
        :level => @level1,
        :progress => 5
      )
      
      @new_rank = @character.mission_levels.rank_for(@mission)

      @new_rank.should be_new_record
      @new_rank.level.should == @level2
      @new_rank.character.should == @character
    end
  end

  describe 'when fetching a list of completed missions in a group' do
    before do
      @group = Factory(:mission_group)

      @mission1 = Factory(:mission_with_level, :mission_group => @group)
      @mission2 = Factory(:mission_with_level, :mission_group => @group)

      @other_group = Factory(:mission_group)

      @mission3 = Factory(:mission_with_level, :mission_group => @other_group)

      @character = Factory(:character)
    end

    it 'should return empty array when there is no completed missions' do
      @character.missions.completed_ids(@group).should == []
    end

    describe 'when there are completed missions' do
      def complete_mission!(mission)
        MissionLevelRank.create(
          :level      => mission.levels.first,
          :character  => @character,
          :progress   => mission.levels.first.win_amount
        )
        @character.missions.check_completion!(mission)
      end

      it 'should return ID of only completed missions' do
        complete_mission!(@mission1)

        @character.missions.completed_ids(@group).should == [@mission1.id]
      end

      it 'should not return IDs of completed missions from other groups' do
        complete_mission!(@mission1)
        complete_mission!(@mission3)

        @character.missions.completed_ids(@group).should == [@mission1.id]
        @character.missions.completed_ids(@other_group).should == [@mission3.id]
      end
    end
  end

  describe 'mission helps' do
    describe 'when fetching uncollected mission helps' do
      before do
        @character = Factory(:character)
      end
    
      it 'should scope to results for the character' do
        @result1 = Factory(:mission_help_result, :requester => @character)
        @result2 = Factory(:mission_help_result)
      
        @character.mission_helps.uncollected.should == [@result1]
      end

      it 'should scope to uncollected help results' do
        @result1 = Factory(:mission_help_result, :requester => @character)
        @result2 = Factory(:mission_help_result, :requester => @character, :collected => true)
      
        @character.mission_helps.uncollected.should == [@result1]
      end
    
      it 'should order results by creation date (recent first)' do
        @result1 = Factory(:mission_help_result, :requester => @character)

        Timecop.travel(1.minute.ago) do
          @result2 = Factory(:mission_help_result, :requester => @character)
        end

        @character.mission_helps.uncollected.should == [@result1, @result2]
      end
    end
    
    describe 'when collecting reward' do
      before do
        @character = Factory(:character)
        
        @result1 = Factory(:mission_help_result, :requester => @character)
        @result2 = Factory(:mission_help_result, :requester => @character)
        
        MissionHelpResult.update_all(:basic_money => 10, :experience => 20)
      end
      
      it 'should give all collected money to character' do
        lambda{
          @character.mission_helps.collect_reward!
        }.should change(@character, :basic_money).from(0).to(20)
      end
      
      it 'should give all collected experience to character' do
        lambda{
          @character.mission_helps.collect_reward!
        }.should change(@character, :experience).from(0).to(40)
      end
      
      it 'should save applied payouts' do
        @character.mission_helps.collect_reward!
        
        @character.should_not be_changed
      end
      
      it 'should mark all uncollected results as collected' do
        lambda{
          @character.mission_helps.collect_reward!
        }.should change(@character.mission_helps.uncollected, :size).from(2).to(0)
      end
      
      it 'should not collect reward from already collected results' do
        @result3 = Factory(:mission_help_result, :requester => @character, :collected => true)
        
        @character.mission_helps.collect_reward!
        
        @character.basic_money.should == 20
        @character.experience.should == 40
      end
      
      it 'should return an array with collected money and experience' do
        @character.mission_helps.collect_reward!.should == [20, 40]
      end
    end
  end
end