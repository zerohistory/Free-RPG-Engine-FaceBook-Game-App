require 'spec_helper'

describe MissionLevel do
  describe '#applicable_payouts' do
    before do
      @level = Factory(:mission_level, 
        :payouts => Payouts::Collection.new(DummyPayout.new(:name => 'level'))
      )
      @level.mission.stub!(:applicable_payouts).and_return(Payouts::Collection.new(DummyPayout.new(:name => 'mission')))
    end
    
    it 'should return payout collection' do
      @level.applicable_payouts.should be_kind_of(Payouts::Collection)
    end
    
    it 'should return level payouts and applicable mission payouts' do
      @level.applicable_payouts.size.should == 2
      @level.applicable_payouts.first.name.should == 'level'
      @level.applicable_payouts.last.name.should == 'mission'
    end
  end
end