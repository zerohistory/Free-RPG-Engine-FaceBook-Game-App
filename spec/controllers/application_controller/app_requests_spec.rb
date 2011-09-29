require 'spec_helper'

describe ApplicationController do
  class FakeController < ApplicationController
    def index; render :text => "foo"; end
    def do_redirect_by_app_request; redirect_by_app_request || render(:text => "foo"); end
    
    around_filter :check_user_app_requests, :only => :with_request_processing
    def with_request_processing
      render(:text => "foo")
    end
  end
  
  controller_name :fake
  
  before do
    controller.stub!(:current_facebook_user).and_return(fake_fb_user)
    controller.stub!(:current_user).and_return(mock_model(User, :id => 123456789))
    controller.stub!(:current_character).and_return(mock_model(Character))
  end
  
  
  describe '#app_request_ids' do
    def do_request(params = {})
      get :do_app_request_ids, {:request_ids => "123,456"}.merge(params)
    end
    
    it 'should return array of request IDs passed in params' do
      controller.params[:request_ids] = "123,456"
      
      controller.send(:app_request_ids).should == [123, 456]
    end
    
    it 'should return empty array if params are empty' do
      controller.send(:app_request_ids).should be_empty
    end
  end
  
  
  describe '#visit_from_app_request?' do
    it 'should return true if request IDs are passed' do
      controller.stub!(:app_request_ids).and_return([123, 456])
      
      controller.send(:visit_from_app_request?).should be_true
    end
    
    it 'should return false if request IDs are not passed' do
      controller.stub!(:app_request_ids).and_return([])
      
      controller.send(:visit_from_app_request?).should be_false
    end
  end
  
  
  describe '#visit_from_bookmark_counter?' do
    it 'should return true when went from bookmark and counter is not 0' do
      controller.params[:ref] = 'bookmarks'
      controller.params[:count] = '1'
      
      controller.send(:visit_from_bookmark_counter?).should be_true
    end
    
    it 'should return false if counter is 0 or not set' do
      controller.params[:ref] = 'bookmarks'

      controller.send(:visit_from_bookmark_counter?).should be_false

      controller.params[:count] = '0'

      controller.send(:visit_from_bookmark_counter?).should be_false
    end
    
    it 'should return false if didn\'t came from bookmark' do
      controller.params[:count] = '123'

      controller.send(:visit_from_bookmark_counter?).should be_false
    end
  end


  describe '#app_requests' do
    before do
      @request1 = mock_model(AppRequest::Base, :visit => true)
      @request2 = mock_model(AppRequest::Base, :visit => true)

      controller.stub!(:visit_from_app_request?).and_return(true)
      controller.stub!(:app_request_ids).and_return([123, 456])

      AppRequest::Base.stub!(:find_all_by_facebook_id).and_return([@request1, @request2])
    end
    
    it 'should fetch requests by passed IDs' do
      AppRequest::Base.should_receive(:find_all_by_facebook_id).with([123, 456])
      
      controller.send(:app_requests)
    end
    
    it 'should return array of requests' do
      controller.send(:app_requests).should == [@request1, @request2]
    end
    
    it 'should not try to fetch requests if visit is not by app request' do
      controller.stub!(:visit_from_app_request?).and_return(false)
      
      AppRequest::Base.should_not_receive(:find_all_by_facebook_id)
      
      controller.send(:app_requests)
    end
  end
  
  
  describe '#redirect_by_app_request' do
    def do_request
      get :do_redirect_by_app_request
    end
    
    before do
      controller.stub!(:visit_from_app_request?).and_return(true)
    end
    
    it 'should clear return URL in session' do
      session[:return_to] = '/other_url'
      
      do_request
      
      response.session[:return_to].should be_nil
    end
    
    it 'should redirect to application request list page' do
      do_request
      
      response.should redirect_from_iframe_to('http://apps.facebook.com/test/app_requests')
    end
    
    it 'should redirect to application request even if return URL is in the session' do
      session[:return_to] = '/other_url'
      
      do_request
      
      response.should redirect_from_iframe_to('http://apps.facebook.com/test/app_requests')
    end
    
    describe 'when not a visit by app request' do
      before do
        controller.stub!(:visit_from_app_request?).and_return(false)
      end
      
      it 'should not redirect' do
        do_request
        
        response.should_not redirect_from_iframe
      end
      
      it 'should return nil' do
        do_request
        
        response.body.should == 'foo'
      end
    end
  end
  
  
  describe 'when request processing with application requests' do
    before do
      @request1 = mock_model(AppRequest::Base, :visit => true)
      @request2 = mock_model(AppRequest::Base, :visit => true)
      
      controller.stub!(:app_requests).and_return([@request1, @request2])
    end
    
    def do_request
      get :with_request_processing
    end
    
    shared_examples_for 'request check' do
      it 'should schedule user request check' do
        lambda{
          do_request
        }.should change(Delayed::Job, :count).by(1)
        
        Delayed::Job.last.payload_object.should be_kind_of(Jobs::UserRequestCheck)
        Delayed::Job.last.payload_object.user_id.should == 123456789
      end
    end
    
    describe 'when request IDs are passed' do
      before do
        controller.stub!(:visit_from_app_request?).and_return(true)
      end
      
      it_should_behave_like 'request check'
      
      it 'should redirect to application request list' do
        do_request
        
        response.should redirect_from_iframe_to('http://apps.facebook.com/test/app_requests')
      end
      
      it 'should mark current app requests as visited' do
        @request1.should_receive(:visit)
        @request2.should_receive(:visit)
      
        do_request
      end
    
      it 'should not visit requests if user is not authenticated' do
        controller.stub!(:current_facebook_user).and_return(nil)
        controller.stub!(:current_character).and_return(nil)

        @request1.should_not_receive(:visit)
        @request2.should_not_receive(:visit)

        do_request
      end
    end
    
    describe 'when referenced from bookmark and request counter is set' do
      before do
        controller.stub!(:visit_from_bookmark_counter?).and_return(true)
      end
      
      it_should_behave_like 'request check'
    end
  end
end