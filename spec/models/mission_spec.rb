require 'spec_helper'

describe Mission do
  describe 'when updating' do
    before do
      @character = Factory(:character)
      @mission = Factory(:mission)
      @rank = MissionRank.create!(:mission => @mission, :character => @character)
    end
    
    describe 'if mission group is changed' do
      before do
        @new_group = Factory(:mission_group)
        
        @mission.mission_group = @new_group
      end
      
      it 'should update group ID in all linked mission ranks' do
        lambda{
          @mission.save
          @rank.reload
        }.should change(@rank, :mission_group_id).to(@new_group.id)
      end
    end
  end
  
  describe '#applicable_payouts' do
    before do
      @mission = Factory(:mission, 
        :payouts => Payouts::Collection.new(DummyPayout.new(:name => 'mission'))
      )
      @mission.mission_group.stub!(:applicable_payouts).and_return(Payouts::Collection.new(DummyPayout.new(:name => 'group')))
    end
    
    it 'should return payout collection' do
      @mission.applicable_payouts.should be_kind_of(Payouts::Collection)
    end
    
    it 'should return payouts from mission and applicable mission group payouts' do
      @mission.applicable_payouts.size.should == 2
      @mission.applicable_payouts.first.name.should == 'mission'
      @mission.applicable_payouts.last.name.should == 'group'
    end
  end
end