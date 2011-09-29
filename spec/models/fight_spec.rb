require 'spec_helper'

describe Fight do
  describe 'when creating' do
    before do
      @attacker = Factory(:character)
      @victim = Factory(:character)
      @fight = Fight.new(:attacker => @attacker, :victim => @victim)
      
      @payout = Factory(:global_payout,
        :alias => 'fights',
        :payouts => Payouts::Collection.new(
          DummyPayout.new(:apply_on => :success, :name => 'success'), 
          DummyPayout.new(:apply_on => :failure, :name => 'failure')
        )
      )
      
      @payout.publish!
    end
    
    it 'should give an error when attacker doesn\'t have enough stamina'
    
    it 'should give an error when victim is too weak (if configured that way)' do
      @victim.hp = 0
      @victim.save!
      
      @fight.should be_valid
      
      with_setting(:fight_weak_opponents => false) do
        @fight.should_not be_valid
        @fight.errors.on(:victim).should =~ /too weak/
      end
    end
    
    it 'should give an error when attacking alliance member if configured that way'
    it 'should give an error when attacker is weak'
    it 'should give an error when trying to attack yourself'
    it 'should give an error when trying to respond to fight that is not respondable'
    it 'should give an error when trying to attack a victim that attacker cannot attack'
    
    it 'should be successfully created' do
      @fight.save.should be_true
    end
    
    describe 'when won the fight' do
      before do
        Fight.fighting_system.stub!(:calculate).and_return(true)
      end
      
      it 'should apply global :success payout' do        
        @fight.save
        
        @fight.payouts.should be_kind_of(Payouts::Collection)
        @fight.payouts.size.should == 1
        @fight.payouts.first.should be_applied
        @fight.payouts.first.name.should == 'success'
      end
    end
    
    describe 'when lost the fight' do
      before do
        Fight.fighting_system.stub!(:calculate).and_return(false)
      end

      it 'should apply global :success payout' do        
        @fight.save
        
        @fight.payouts.should be_kind_of(Payouts::Collection)
        @fight.payouts.size.should == 1
        @fight.payouts.first.should be_applied
        @fight.payouts.first.name.should == 'failure'
      end
    end
  end
end