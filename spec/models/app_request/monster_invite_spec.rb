require 'spec_helper'
require 'models/app_request/common'

describe AppRequest::MonsterInvite do
  describe '#monster' do
    before do
      @request = Factory(:app_request_monster_invite)
    end
    
    it 'should return monster by ID stored in data' do
      @request.monster.should == Monster.first
    end
    
    it 'should return nil if ID is not set' do
      @request.data = nil
      
      @request.monster.should be_nil
    end
  end
  
  
  describe '#accept' do
    before do
      @receiver = Factory(:user_with_character)

      @request  = Factory(:app_request_monster_invite)
    end
    
    it_should_behave_like 'application request accept'
    
    it 'should join receiver to monster fight' do
      lambda{
        @request.accept
      }.should change(@receiver.character.monster_fights, :count).from(0).to(1)
      
      @receiver.character.monster_fights.first.monster.should == @request.monster
    end
  end
end