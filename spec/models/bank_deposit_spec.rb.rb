require 'spec_helper'
require File.expand_path('../bank_operation_spec.rb', __FILE__)

describe BankDeposit do
  before do
    @character = Factory(:character, :basic_money => 100)
    
    @operation = BankDeposit.new(:amount => 100)
    @operation.character = @character
  end

  it_should_behave_like 'bank operation'
  
  describe 'when creating' do
    it 'should not save when character doesn\'t have enough money' do
      @operation.amount = 101
      
      @operation.save.should be_false
      @operation.errors.on(:amount).should_not be_empty
    end
    
    it 'should successfully save' do
      @operation.save.should be_true
    end
    
    it 'should put money to character\'s bank and take processing fee' do
      lambda{
        @operation.save
      }.should change(@character, :basic_money).from(100).to(0)
      
      @character.bank.should == 90
    end    
  end
end