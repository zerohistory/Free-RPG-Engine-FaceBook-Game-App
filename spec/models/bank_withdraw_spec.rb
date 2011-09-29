require 'spec_helper'
require File.expand_path('../bank_operation_spec.rb', __FILE__)

describe BankWithdraw do
  before do
    @character = Factory(:character, :bank => 100)
    
    @operation = BankWithdraw.new(:amount => 100)
    @operation.character = @character
  end

  it_should_behave_like 'bank operation'
  
  describe 'when creating' do
    it 'should not save when character doesn\'t have enough money in bank' do
      @operation.amount = 101
      
      @operation.save.should be_false
      @operation.errors.on(:amount).should_not be_empty
    end
    
    it 'should successfully save' do
      @operation.save.should be_true
    end
    
    it 'should take money from character\'s bank' do
      lambda{
        @operation.save
      }.should change(@character, :bank).from(100).to(0)
      
      @character.basic_money.should == 100
    end    
  end
end