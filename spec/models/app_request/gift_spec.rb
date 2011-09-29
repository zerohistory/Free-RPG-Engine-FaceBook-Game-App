require 'spec_helper'
require 'models/app_request/common'

describe AppRequest::Gift do
  describe '.accepted_recently?' do
    before do
      @request = Factory(:app_request_gift)      

      @sender   = @request.sender
      @receiver = Factory(:character)
    end
    
    it 'should return true if receiver has gifts from sender accepted less than 24 hours ago' do
      @request.accept
      
      AppRequest::Gift.accepted_recently?(@sender, @receiver).should be_true
    end
    
    it 'should return false if no gifts in last 24 hours' do
      AppRequest::Gift.accepted_recently?(@sender, @receiver).should be_false
      
      Timecop.travel((24.hours + 1.minute).ago) do
        @request.accept!
      end
      
      AppRequest::Gift.accepted_recently?(@sender, @receiver).should be_false
    end
  end

  describe '#item' do
    before do
      @request = Factory(:app_request_gift)
    end
    
    it 'should return item by ID stored in data' do
      @request.item.should == Item.first
    end
    
    it 'should return nil if ID is not set' do
      @request.data = nil
      
      @request.item.should be_nil
    end
  end
  
  
  describe '#accept' do
    before do
      @receiver = Factory(:user_with_character)
      @request  = Factory(:app_request_gift)
    end
    
    it_should_behave_like 'application request accept'
    
    it 'should fail if receiver already accepted a gift from the same sender recently' do
      @other_request = @request.clone
      @other_request.save
      
      @other_request.accept
      
      @request.accept.should be_false
      @request.errors.on(:base).should =~ /You already accepted a gift from this player recently/i
    end
    
    it 'should give item to receiver' do
      lambda{
        @request.accept
      }.should change(@receiver.character.inventories, :count).from(0).to(1)
      
      @request.inventory.should == @receiver.character.inventories.first
    end
  end
  
  describe '#acceptable?' do
    before do
      @receiver = Factory(:character)
      @request = Factory(:app_request_gift)
    end
    
    it 'should return false if receiver recently accepted a gift from the sender' do
      @other_request = Factory(:app_request_gift, :sender => @request.sender)
      
      @other_request.accept
      
      @request.acceptable?.should be_false
    end
    
    it 'should return false if gift is already accepted' do
      Timecop.travel(1.week.ago) do
        @request.accept
      end
      
      @request.acceptable?.should be_false
    end
    
    it 'should return true in other cases' do
      @request.acceptable?.should be_true
    end
  end
end