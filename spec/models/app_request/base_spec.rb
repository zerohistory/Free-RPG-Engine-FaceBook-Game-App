require 'spec_helper'
require 'models/app_request/common'

describe AppRequest::Base do
  describe 'associations' do
    before do
      @request = AppRequest::Base.new
    end
    
    it 'should belong to sender' do
      @request.should belong_to(:sender)
    end
  end
  
  describe 'states' do
    before do
      @request = Factory(:app_request_base)
    end
    
    describe 'when pending' do
      before do
        @request.update_attribute(:state, 'pending')
      end
      
      it 'should be processable' do
        @request.can_process?.should be_true
      end
      
      it 'should be visitable' do
        @request.can_visit?.should be_true
      end

      it 'should be ignorable' do
        @request.can_ignore?.should be_true
      end

      it 'should not be acceptable' do
        @request.can_accept?.should_not be_true
      end
    end
    
    describe 'when processed' do
      it 'should be acceptable' do
        @request.can_accept?.should be_true
      end
      
      it 'should be ignorable' do
        @request.can_ignore?.should be_true
      end

      it 'should be visitable' do
        @request.can_visit?.should be_true
      end
    end
    
    describe 'when visited' do
      before do
        @request.update_attribute(:state, 'visited')
      end
      
      it 'should be acceptable' do
        @request.can_accept?.should be_true
      end
      
      it 'should be ignorable' do
        @request.can_ignore?.should be_true
      end
    end
  end
  
  describe '.for_character' do
    before do
      @receiver = Factory(:user_with_character).character
      
      @request1 = Factory(:app_request_base, :receiver_id => 123456789)
      @request2 = Factory(:app_request_base, :receiver_id => 123456789)
      @request3 = Factory(:app_request_base, :receiver_id => 111222333)
    end
    
    it 'should return gifts sent to passed character' do
      AppRequest::Base.for(@receiver).should include(@request1, @request2)
      AppRequest::Base.for(@receiver).should_not include(@request3)
    end
  end
  
  
  describe '.mogli_client' do
    before do
      @client = mock('mogli client')
      
      Mogli::AppClient.stub!(:create_and_authenticate_as_application).and_return(@client)
    end
    
    it 'should instantiate new client' do
      Mogli::AppClient.should_receive(:create_and_authenticate_as_application).with(123456789, '21ba0987654321dcba0987654321dcba').and_return(@client)
      
      AppRequest::Base.mogli_client
    end
    
    it 'should return client' do
      AppRequest::Base.mogli_client.should == @client
    end
  end
  
  
  describe '.check_user_requests' do
    before do
      @user = mock_model(User, :facebook_id => 123456789)
      
      @facebook_user = mock('remote_user', 
        :apprequests => [
          mock('request 1', :id => 123), 
          mock('request 2', :id => 456)
        ]
      )
      
      Mogli::User.stub!(:find).and_return(@facebook_user)
      
      @request1 = mock_model(AppRequest::Base, :update_from_facebook_request => true, :pending? => true)
      @request2 = mock_model(AppRequest::Base, :update_from_facebook_request => true, :pending? => false)
      
      AppRequest::Base.stub!(:find_or_initialize_by_facebook_id).and_return(@request1, @request2)

      @client = mock('mogli client')
      AppRequest::Base.stub!(:mogli_client).and_return(@client)
    end
    
    it 'should fetch app request data from facebook' do
      Mogli::User.should_receive(:find).with(123456789, @client, :apprequests).and_return(@facebook_user)
      
      AppRequest::Base.check_user_requests(@user)
    end
    
    it 'should find or initialize new request for each facebook request' do
      AppRequest::Base.should_receive(:find_or_initialize_by_facebook_id).twice.and_return(@request1, @request2)
      
      AppRequest::Base.check_user_requests(@user)
    end
    
    it 'should update data for each pending request' do
      @request1.should_receive(:update_from_facebook_request)
      
      AppRequest::Base.check_user_requests(@user)
    end
    
    it 'should not update requests if they\'re not pending' do
      @request2.should_not_receive(:update_from_facebook_request)
      
      AppRequest::Base.check_user_requests(@user)
    end
  end
  
  
  describe '.schedule_deletion' do
    before do
      @request1 = Factory(:app_request_base)
      @request2 = Factory(:app_request_gift)
    end
    
    it 'should schedule deletion for passed request IDs' do
      lambda{
        AppRequest::Base.schedule_deletion(@request1.id, @request2.id)
      }.should change(Delayed::Job, :count).by(1)
      
      Delayed::Job.last.payload_object.should be_kind_of(Jobs::RequestDelete)
      Delayed::Job.last.payload_object.request_ids.should == [@request1.id, @request2.id]
    end
    
    it 'should correctly accept array of requests' do
      lambda{
        AppRequest::Base.schedule_deletion(@request1, @request2)
      }.should change(Delayed::Job, :count).by(1)
      
      Delayed::Job.last.payload_object.should be_kind_of(Jobs::RequestDelete)
      Delayed::Job.last.payload_object.request_ids.should == [@request1.id, @request2.id]
    end
    
    it 'should ignore nil values in passed params' do
      lambda{
        AppRequest::Base.schedule_deletion(@request1, nil)
      }.should change(Delayed::Job, :count).by(1)
      
      Delayed::Job.last.payload_object.should be_kind_of(Jobs::RequestDelete)
      Delayed::Job.last.payload_object.request_ids.should == [@request1.id]
    end
    
    it 'should not schedule any jobs if result ID array is empty' do
      lambda{
        AppRequest::Base.schedule_deletion(nil)
      }.should_not change(Delayed::Job, :count)
    end
    
    it 'should accept nested arrays' do
      lambda{
        AppRequest::Base.schedule_deletion([@request1], @request2)
      }.should change(Delayed::Job, :count).by(1)
      
      Delayed::Job.last.payload_object.should be_kind_of(Jobs::RequestDelete)
      Delayed::Job.last.payload_object.request_ids.should == [@request1.id, @request2.id]
    end
    
    it 'should now repeatedly schedule deletion if requests do repeat' do
      lambda{
        AppRequest::Base.schedule_deletion([@request1, @request2], @request1, @request1.id, @request2, @request2.id)
      }.should change(Delayed::Job, :count).by(1)
      
      Delayed::Job.last.payload_object.should be_kind_of(Jobs::RequestDelete)
      Delayed::Job.last.payload_object.request_ids.should == [@request1.id, @request2.id]
    end
  end
  

  describe 'when creating' do
    before do
      @request = AppRequest::Base.new(:facebook_id => 123)
    end
    
    it 'should validate presence of facebook ID' do
      @request.should validate_presence_of(:facebook_id)
    end
    
    it 'should successfully save' do
      @request.save.should be_true
    end
    
    it 'should schedule data update' do
      lambda{
        @request.save
      }.should change(Delayed::Job, :count).by(1)
      
      Delayed::Job.last.payload_object.should be_kind_of(Jobs::RequestDataUpdate)
    end
  end
  
  
  describe '#update_from_facebook_request' do
    before do
      @sender = Factory(:user_with_character, :facebook_id => 123)
      
      @request = Factory(:app_request_base, :state => 'pending')
      
      @remote_request = mock('request on facebook',
        :from => mock('sender', :id => 123),
        :to => mock('receiver', :id => 456),
        :data => '{"type":"gift"}'
      )
    end
    
    it 'should assign sender' do
      lambda{
        @request.update_from_facebook_request(@remote_request)
      }.should change(@request, :sender).from(nil).to(@sender.character)
    end
    
    it 'should assign receiver ID' do
      lambda{
        @request.update_from_facebook_request(@remote_request)
      }.should change(@request, :receiver_id).from(nil).to(456)
    end
    
    it 'should parse and assign request data' do
      lambda{
        @request.update_from_facebook_request(@remote_request)
      }.should change(@request, :data).from(nil).to('type' => 'gift')
    end
    
    it 'should not try to parse empty request data' do
      @remote_request.should_receive(:data).and_return(nil)
      
      lambda{
        @request.update_from_facebook_request(@remote_request)
      }.should_not change(@request, :data)
    end
    
    it 'should save request' do
      lambda{
        @request.update_from_facebook_request(@remote_request)
      }.should change(@request, :data)
    end
    
    it 'should mark request as processed' do
      lambda{
        @request.update_from_facebook_request(@remote_request)
      }.should change(@request, :processed?).from(false).to(true)
    end
    
    it 'should ignore request if remote request sender is not defined' do
      @remote_request.stub!(:from).and_return(nil)
      
      lambda{
        @request.update_from_facebook_request(@remote_request)
      }.should change(@request, :ignored?).from(false).to(true)
    end
    
    describe 'when reuest type is set' do
      it 'should change request class to gift if request is a gift request' do
        @remote_request.stub!(:data).and_return('{"type":"gift"}')

        @request.update_from_facebook_request(@remote_request)

        AppRequest::Base.find(@request.id).should be_kind_of(AppRequest::Gift)
      end

      it 'should change request class to invitation if request is a invitation request' do
        @remote_request.stub!(:data).and_return('{"type":"invitation"}')

        @request.update_from_facebook_request(@remote_request)

        AppRequest::Base.find(@request.id).should be_kind_of(AppRequest::Invitation)
      end

      it 'should change request class to monster invite if request is a monster invite request' do
        @remote_request.stub!(:data).and_return('{"type":"monster_invite"}')

        @request.update_from_facebook_request(@remote_request)

        AppRequest::Base.find(@request.id).should be_kind_of(AppRequest::MonsterInvite)
      end
    end
    
    describe 'when type is not set' do
      it 'should change request class to gift if tiem ID is set' do
        @remote_request.stub!(:data).and_return('{"item_id":123}')

        @request.update_from_facebook_request(@remote_request)

        AppRequest::Base.find(@request.id).should be_kind_of(AppRequest::Gift)
      end

      it 'should change request class to invitation if data is not set' do
        @remote_request.stub!(:data).and_return(nil)

        @request.update_from_facebook_request(@remote_request)

        AppRequest::Base.find(@request.id).should be_kind_of(AppRequest::Invitation)
      end

      it 'should change request class to invitation if data is set but no item or monster ID' do
        @remote_request.stub!(:data).and_return('{"something":"else"}')

        @request.update_from_facebook_request(@remote_request)

        AppRequest::Base.find(@request.id).should be_kind_of(AppRequest::Invitation)
      end

      it 'should change request class to monster invite if monster ID is set' do
        @remote_request.stub!(:data).and_return('{"monster_id":123}')

        @request.update_from_facebook_request(@remote_request)

        AppRequest::Base.find(@request.id).should be_kind_of(AppRequest::MonsterInvite)
      end
    end
  end
  
  
  describe '#update_data!' do
    before do
      @request = Factory(:app_request_base)
      @request.stub!(:update_from_facebook_request).and_return(true)

      @client = mock('mogli client')
      AppRequest::Base.stub!(:mogli_client).and_return(@client)
      
      Mogli::AppRequest.stub!(:find).and_return(@remote_request)
    end

    it 'should fetch data from API using application token' do
      Mogli::AppRequest.should_receive(:find).with(123456789, @client).and_return(@remote_request)
      
      @request.update_data!
    end
    
    it 'should update request from remote request' do
      @request.should_receive(:update_from_facebook_request).and_return(true)
      
      @request.update_data!
    end
  end
  
  
  describe '#receiver' do
    before do
      @receiver = Factory(:user_with_character).character
      @request = Factory(:app_request_base, :receiver_id => 123456789)
    end
    
    it 'should return character for user with facebook UID equal to stored receiver ID' do
      @request.receiver.should == @receiver
    end
    
    it 'should return nil if there is no character for such UID' do
      @request = Factory(:app_request_base, :receiver_id => 111222333)
      
      @request.receiver.should be_nil
    end
    
    it 'should memoize receiver' do
      @request.receiver
      
      User.should_not_receive(:find_by_facebook_id)
      
      @request.receiver
    end
  end
  
  
  describe '#acceptable?' do
    it 'should always return true' do
      Factory(:app_request_base).acceptable?.should be_true
    end
  end


  describe '#delete_from_facebook!' do
    before do
      @request = Factory(:app_request_base)
      
      @client = mock('mogli client')
      
      Mogli::AppClient.stub!(:create_and_authenticate_as_application).and_return(@client)
      
      @remote_request = mock('request on facebook', :destroy => true)
      
      Mogli::AppRequest.stub!(:new).and_return(@remote_request)
    end
    
    it 'should delete request from facebook using application access token' do
      Mogli::AppRequest.should_receive(:new).with({:id => 123456789}, @client).and_return(@remote_request)
      
      @remote_request.should_receive(:destroy)
      
      @request.delete_from_facebook!
    end
  end


  describe '#process' do
    before do
      @request = Factory(:app_request_base, :state => 'pending')
    end
    
    it 'should store processing time' do
      Timecop.freeze(Time.now) do
        lambda{
          @request.process
          @request.reload
        }.should change(@request, :processed_at).from(nil).to(Time.at(Time.now.to_i))
      end
    end
  end


  describe '#visit' do
    before do
      @request = Factory(:app_request_base)
    end
    
    it 'should store visit time' do
      Timecop.freeze(Time.now) do
        lambda{
          @request.visit
          @request.reload
        }.should change(@request, :visited_at).from(nil).to(Time.at(Time.now.to_i))
      end
    end
  end


  describe "#accept" do
    before do
      @request = Factory(:app_request_base)
    end
  
    it_should_behave_like 'application request accept'
  end


  describe '#ignore' do
    before do
      @request = Factory(:app_request_base)
    end
    
    it 'should schedule request deletion' do
      lambda{
        @request.ignore
      }.should change(Delayed::Job, :count).by(1)

      Delayed::Job.last.payload_object.should be_kind_of(Jobs::RequestDelete)
      Delayed::Job.last.payload_object.request_ids.should == [@request.id]
    end
  end
end