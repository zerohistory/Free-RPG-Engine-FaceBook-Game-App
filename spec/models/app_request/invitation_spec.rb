require 'spec_helper'
require 'models/app_request/common'

describe AppRequest::Invitation do
  describe '#accept' do
    before do
      @receiver = Factory(:character)

      @request  = Factory(:app_request_invitation, :state => 'processed')
    end
    
    it_should_behave_like 'application request accept'
    
    it 'should create relations between sender and receiver' do
      @request.accept
      
      @receiver.friend_relations.established?(@request.sender).should be_true
    end
    
    it 'should mark all other invitations between these users as ignored' do
      @other_request = Factory(:app_request_invitation, :sender => @request.sender)
      
      lambda{
        @request.accept
        
        @other_request.reload
      }.should change(@other_request, :state).from('processed').to('ignored')
    end
  end
end