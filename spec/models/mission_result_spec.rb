require 'spec_helper'

describe MissionResult do
  before do
    @character = Factory(:character)

    @group = Factory(:mission_group)
    @mission = Factory(:mission, :mission_group => @group)
    @mission_level = Factory(:mission_level, :mission => @mission)

    @payout_success = DummyPayout.new(:apply_on => :success)
    @payout_failure = DummyPayout.new(:apply_on => :failure)
    @payout_repeat_success = DummyPayout.new(:apply_on => :repeat_success)
    @payout_repeat_failure = DummyPayout.new(:apply_on => :repeat_failure)
    @payout_level_complete = DummyPayout.new(:apply_on => :level_complete)
    @payout_mission_complete = DummyPayout.new(:apply_on => :mission_complete)
    @payout_group_complete = DummyPayout.new(:apply_on => :mission_group_complete)

    @payouts = Payouts::Collection.new(
      @payout_success, 
      @payout_failure,
      @payout_repeat_success,
      @payout_repeat_failure,
      
      @payout_level_complete,
      @payout_mission_complete,
      @payout_group_complete
    )
    
    @result = MissionResult.new(@character, @mission)
  end

  def progress_level!(level, progress)
    MissionLevelRank.create(
      :level      => level,
      :character  => @character,
      :progress   => progress
    )
    @character.missions.check_completion!(@mission)
  end

  describe 'when checking if enough energy for mission' do
    it 'should return true when character has enough energy' do
      @result.enough_energy?.should be_true
    end

    it 'should return false when character\'s energy is lower than required' do
      @character.ep = 4

      @result.enough_energy?.should_not be_true
    end
  end

  describe 'when checking if mission performance succeed' do
    it 'should roll dice with level chance and return its result' do
      Dice.should_receive(:chance).with(50, 100).and_return(true)

      @result.success?.should be_true
    end

    it 'should roll dice only once' do
      Dice.should_receive(:chance).once.and_return(false)

      result = @result
      result.success?.should be_false
      result.success?.should be_false
    end
  end

  describe 'when checking if mission result is a new record' do
    it 'should return true if result wasn\'t saved' do
      @result.new_record?
    end

    it 'should return false when result saved' do
      @result.save!
      @result.new_record?.should be_false
    end
  end

  describe 'when checking if mission was fulfilled for free' do
    before do
      @character.assignments.stub!(:mission_energy_effect => 42)
    end

    it 'should roll dice with assignment effect for mission energy and return its result' do
      Dice.should_receive(:chance).with(42, 100).and_return(true)

      @result.free_fulfillment?.should be_true
    end

    it 'should roll dice only once' do
      Dice.should_receive(:chance).once.and_return(false)

      result = @result

      result.free_fulfillment?.should be_false
      result.free_fulfillment?.should be_false
    end
  end

  describe 'when checking if requirements are satisfied' do
    it 'should return true if there are no requirements' do
      @mission.requirements = nil

      @result.requirements_satisfied?.should be_true
    end

    it 'should return true when requirements are satisfied' do
      @mission.requirements = Requirements::Collection.new(
        DummyRequirement.new(:should_satisfy => true)
      )

      @result.requirements_satisfied?.should be_true
    end
    
    it 'should return false when requirements are not satisfied' do
      @mission.requirements = Requirements::Collection.new(
        DummyRequirement.new(:should_satisfy => false)
      )

      @result.requirements_satisfied?.should be_false
    end

    it 'should check requirements only once' do
      @requirement = DummyRequirement.new(:should_satisfy => false)
      @mission.requirements = Requirements::Collection.new(@requirement)

      @requirement.should_receive(:satisfies?).once.and_return(false)

      result = @result

      result.requirements_satisfied?.should be_false
      result.requirements_satisfied?.should be_false
    end
  end

  describe 'when performing mission' do
    it 'should not be saved if character doesn\'t have enough energy' do
      @character.ep = 0

      @result.save!
      @result.should_not be_saved
    end

    it 'should not be saved if mission is not repeatable and current level is already completed' do
      @result.level_rank.update_attributes(
        :progress => @mission_level.win_amount
      )
      @character.missions.check_completion!(@mission)

      @result.save!
      @result.should_not be_saved
    end

    it 'should not be saved if mission requirements are not satisfied' do
      @mission.requirements = Requirements::Collection.new(
        DummyRequirement.new(:should_satisfy => false)
      )

      @result.save!
      @result.should_not be_saved
    end

    describe 'when mission is valid' do
      it 'should succeed if we hit success chance' do
        Dice.should_receive(:chance).at_least(1).and_return(true)

        @result.save!
        @result.should be_success
      end

      it 'should not succeed if we don\'t hit success chance' do
        Dice.should_receive(:chance).at_least(1).and_return(false)

        @result.save!
        @result.should_not be_success
      end

      it 'should be done for free if we hit character\'s mission energy assignment chance' do
        @character.assignments.should_receive(:mission_energy_effect).and_return(20)

        Dice.should_receive(:chance).at_least(1).and_return(true)

        result = @result

        lambda{
          result.save!
        }.should_not change(@character, :ep)

        result.should be_free_fulfillment
      end

      describe 'when not done for free' do
        it 'should charge energy' do
          lambda{
            @result.save!
          }.should change(@character, :ep).from(10).to(5)
        end

        describe 'when character have boosts' do
          before do
            @energy_boost = Factory(:item, :boost => true)

            @character.inventories.give!(@energy_boost)
          end
                    
          describe 'when boost has energy bonus within required value' do
            before do
              @energy_boost.update_attributes(:energy => 4)
            end

            it 'should use energy boost' do
              @result.save!
              @result.boost.item.should == @energy_boost
            end
            
            it 'should reduce energy cost by boost bonus' do
              lambda{
                @result.save!
              }.should change(@character, :ep).from(10).to(9)
            end

            it 'should take boost from character' do
              @result.save!

              @character.inventories.should be_empty
            end
          end

          shared_examples_for 'boost that don\'t fit' do
            it 'should not use boost' do
              @result.save!
              @result.boost.should be_nil
            end

            it 'should charge energy in full' do
              lambda{
                @result.save!
              }.should change(@character, :ep).from(10).to(5)
            end

            it 'should not take boost from character' do
              @result.save!

              @character.inventories.should_not be_empty
            end
          end

          describe 'when boost does\'t have energy bonus' do
            before do
              @energy_boost.update_attributes(:attack => 1)
            end

            it_should_behave_like "boost that don\'t fit"
          end

          describe 'when boost is more powerfull than requires' do
            before do
              @energy_boost.update_attribute(:energy, 10)
            end

            it_should_behave_like "boost that don\'t fit"
          end
        end
      end

      describe 'when done successfully' do
        before do
          Dice.stub!(:chance => true)
        end
        
        it 'should give experience to user' do
          lambda{
            @result.save!
          }.should change(@character, :experience).from(0).to(5)

          @result.experience.should == 5
        end

        it 'should give money to user' do
          @result.level.should_receive(:money).and_return(100)

          lambda{
            @result.save!
          }.should change(@character, :basic_money).from(0).to(100)

          @result.money.should == 100
        end

        it 'should increase level progress' do
          @result.save!

          @character.mission_levels.rank_for(@mission).progress.should == 1
        end

        it 'should increase succeeded mission counter' do
          lambda{
            @result.save!
          }.should change(@character, :missions_succeeded).from(0).to(1)
        end

        describe 'if level is just completed' do
          before do
            progress_level!(@mission_level, 4)

            @result = MissionResult.new(@character.reload, @mission.reload)
          end

          it 'should increase completed mission counter' do
            lambda{
              @result.save!
            }.should change(@character, :missions_completed).from(0).to(1)
          end


          it 'should increase mastered mission counter if doing last level of the mission' do
            @second_level = Factory(:mission_level, :mission => @mission)
            @second_level.move_higher

            progress_level!(@second_level, 5)
            
            @character.missions.check_completion!(@mission)

            @result = MissionResult.new(@character.reload, @mission.reload)

            lambda{
              @result.save!
            }.should change(@character, :missions_mastered).from(0).to(1)
          end

          it 'should not increase mastered mission counter if doing non-last level' do
            @second_level = Factory(:mission_level, :mission => @mission)

            lambda{
              @result.save!
            }.should_not change(@character, :missions_mastered)
          end

          it 'should give upgrade point to character' do
            lambda{
              @result.save!
            }.should change(@character, :points).from(0).to(1)
          end

          it 'should apply :complete payouts of level' do
            result = @result

            result.level.payouts = @payouts

            result.save!

            result.payouts.should include(@payout_level_complete)
            result.payouts.each do |p|
              p.should be_applied
            end
          end

          it 'should check completion of mission and create mission rank record' do
            @result.save!

            @result.mission_rank.should == MissionRank.first

            MissionRank.first.should be_completed
          end

          it 'should apply mission payouts' do
            result = @result

            result.level.payouts = @payouts

            result.save!

            result.payouts.should include(@payout_mission_complete)
            result.payouts.each do |p|
              p.should be_applied
            end
          end
          
          it 'should check completion of mission group and create mission group rank record' do
            @result.save!

            @result.group_rank.should == MissionGroupRank.first
            
            MissionGroupRank.first.should be_completed
          end

          it 'should apply group payouts if mission group completed' do
            result = @result

            result.level.payouts = @payouts

            result.save!

            result.payouts.should include(@payout_group_complete)
            result.payouts.each do |p|
              p.should be_applied
            end
          end
          
          it 'should add news about completed mission to character' do
            lambda{
              @result.save!
            }.should change(@character.news, :count).from(0).to(1)

            @character.news.first.should be_kind_of(News::MissionComplete)
            @character.news.first.mission.should == @mission
            @character.news.first.level_rank.should == MissionLevelRank.first
          end
        end

        describe 'if mission is not completed yet' do
          it 'should apply :success payout' do
            result = @result

            result.level.payouts = @payouts

            result.save!

            result.payouts.should include(@payout_success)
          end
        end

        describe 'if mission is already completed in past' do
          before do
            @mission.update_attributes(:repeatable => true)

            progress_level!(@mission_level, 5)

            @result = MissionResult.new(@character.reload, @mission.reload)
          end
          
          it 'should apply :repeat_success payout' do
            @result.level.payouts = @payouts

            @result.save!

            @result.payouts.size.should == 1
            @result.payouts.first.should == @payout_repeat_success
            @result.payouts.first.should be_applied
          end
        end
      end

      describe 'when failed' do
        it 'should apply :failure payouts if level is not completed yet' do
          @result.stub!(:success? => false)
          @result.level.payouts = @payouts

          @result.save!

          @result.payouts.should include(@payout_failure)
        end

        it 'should apply :repeat_failure payouts if level is already completed' do
          @mission.update_attributes(:repeatable => true)

          progress_level!(@mission_level, 5)

          @result = MissionResult.new(@character.reload, @mission.reload)
          @result.stub!(:success? => false)
          @result.level.payouts = @payouts

          @result.save!

          @result.payouts.should include(@payout_repeat_failure)
        end
      end
    end

    describe 'when mission is repeatable' do
      before do
        @mission.update_attributes(:repeatable => true)
      end

      it 'should be saved if level is already completed' do
        @result.save!

        @result.should be_saved
      end
    end
  end
end