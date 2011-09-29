require 'spec_helper'

describe CharactersController do
  shared_examples_for 'app request processing' do
    it 'should check user app requests' do
      controller.should_receive(:check_user_app_requests).and_return(true)
      
      do_request
    end
  end
  
  describe '#index' do
    def do_request
      get :index
    end
    
    describe 'when user is already registered' do
      before do
        controller.stub!(:current_facebook_user).and_return(fake_fb_user)
        controller.stub!(:current_user).and_return(mock_model(User, :id => 123456789))
        controller.stub!(:current_character).and_return(mock_model(Character))
      end
      
      it_should_behave_like 'app request processing'
    end
  end
end