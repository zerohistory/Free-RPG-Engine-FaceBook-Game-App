require 'spec_helper'

describe MissionsController do
  before do
    controller.stub!(:current_facebook_user).and_return(fake_fb_user)
  end
  
  describe 'routes' do
    it "should map POST /missions/collect_help_reward to reward collection" do
      params_from(:post, "/missions/collect_help_reward").should == {
        :controller   => "missions",
        :action       => "collect_help_reward"
      }
    end
  end
  
  describe 'when helping with a mission' do
    before do
      @character = mock_model(Character)

      controller.stub!(:current_character).and_return(@character)
    end

    it 'should redirect to root if there is no key passed' do
      get :help
      
      response.should redirect_from_iframe_to('http://apps.facebook.com/test/')
    end
  end
  
  describe 'when collection reward from mission help' do
    before do
      @character = mock_model(Character, 
        :mission_helps => mock('mission help results', :collect_reward! => [10, 20])
      )

      controller.stub!(:current_character).and_return(@character)
    end
    
    def do_request
      post :collect_help_reward
    end
    
    it 'should collect reward for current character' do
      @character.mission_helps.should_receive(:collect_reward!).and_return([10, 20])
      
      do_request
    end
    
    it 'should pass payouts to the template' do
      do_request
      
      assigns[:basic_money].should == 10
      assigns[:experience].should == 20
    end
    
    it 'should render \'collect_help_reward\' as AJAX response' do
      do_request

      response.should render_template(:collect_help_reward)
      response.should use_layout('ajax')
    end
  end
end