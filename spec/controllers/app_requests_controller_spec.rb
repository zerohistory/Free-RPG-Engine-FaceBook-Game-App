require 'spec_helper'

describe AppRequestsController do
  describe "when routing" do
    it "should map POST /app_requests to the request creation action" do
      params_from(:post, "/app_requests").should == {
        :controller   => "app_requests",
        :action       => "create"
      }
    end
  end
  
  describe 'when creating requests' do
    before do
      AppRequest::Base.stub!(:create).and_return(true)
    end
    
    def do_request
      post :create, :ids => ['123']
    end
    
    it 'should create new application request for each passed request ID' do
      AppRequest::Base.should_receive(:create).with(:facebook_id => '123')
      
      do_request
    end
    
    it 'should render empty page' do
      do_request
      
      response.body.should be_blank
    end
    
    it 'should not fail if request ids are not passed' do
      lambda{
        post :create
      }.should_not raise_exception
    end
  end
end