require 'spec_helper'

describe GlobalPayout do
  describe 'when creating' do
    it 'should validate name presence' do
      should validate_presence_of :name
    end

    it 'should validate alias presence' do
      should validate_presence_of :alias
    end
  end
  
  describe '#by_alias' do
    before do
      @payout1 = Factory(:global_payout, :alias => 'some_alias')
      @payout2 = Factory(:global_payout, :alias => 'some_alias')
      @payout3 = Factory(:global_payout, :alias => 'some_alias')
      
      @payout1.publish
      @payout2.publish
      @payout3.publish
    end
    
    it 'should find first record with provided alias' do
      GlobalPayout.by_alias('some_alias').should == @payout1
    end
    
    it 'should find only among published records' do
      @payout1.hide
      
      GlobalPayout.by_alias('some_alias').should == @payout2
    end
    
    it 'should equally match by symbol and string' do
      GlobalPayout.by_alias('some_alias').should == GlobalPayout.by_alias(:some_alias)
    end
  end
end