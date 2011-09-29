require 'spec_helper'

shared_examples_for 'bank operation' do
  it 'should belong to character' do
    @operation.should belong_to(:character)
  end
  
  it 'should validate presence of amount' do
    @operation.should validate_presence_of(:amount)
  end
  
  it 'should validate numerticality of amount' do
    @operation.should validate_numericality_of(:amount)
  end
  
  it 'should validate that amount is greater than 0' do
    @operation.should allow_value(1).for(:amount)
    @operation.should_not allow_value(0).for(:amount)
    @operation.should_not allow_value(-1).for(:amount)
  end
end