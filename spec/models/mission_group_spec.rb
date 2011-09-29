require 'spec_helper'

describe MissionGroup do
  describe '#applicable_payouts' do
    before do
      @group = Factory(:mission_group, 
        :payouts => Payouts::Collection.new(DummyPayout.new(:name => 'group'))
      )
      @global_payout = Factory(:global_payout, 
        :alias    => 'missions',
        :payouts  => Payouts::Collection.new(DummyPayout.new(:name => 'global'))
      )
      @global_payout.publish!
    end
    
    it 'should return payout collection' do
      @group.applicable_payouts.should be_kind_of(Payouts::Collection)
    end
    
    it 'should return payouts from group and global payouts' do
      @group.applicable_payouts.size.should == 2
      @group.applicable_payouts.first.name.should == 'group'
      @group.applicable_payouts.last.name.should == 'global'
    end
    
    it 'should return only group payouts if there are no published global payouts' do
      @global_payout.hide
      
      @group.applicable_payouts.size.should == 1
      @group.applicable_payouts.first.name.should == 'group'
    end
  end
end