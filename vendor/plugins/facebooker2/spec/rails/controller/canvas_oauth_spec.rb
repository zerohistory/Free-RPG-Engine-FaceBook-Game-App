require 'spec_helper'

class FakeCanvasOAuthController < ActionController::Base
  include Facebooker2::Rails::Controller::CanvasOAuth

  def callback_url
    "my url"
  end
end

describe Facebooker2::Rails::Controller::CanvasOAuth do
  before(:each) do
    Facebooker2.canvas_page_name = 'my-application'
    Facebooker2.app_id = '12345'

    FakeCanvasOAuthController._facebooker_oauth_callback_url = nil
    FakeCanvasOAuthController._facebooker_scope = nil
  end

  let :controller do
    FakeCanvasOAuthController.new
  end

  describe "should extend with OAuth class methods" do
    [ :ensure_canvas_connected_to_facebook, :create_facebook_oauth_callback ].each do |method|
      it "#{method}" do
        controller.class.respond_to?(method).should be_true
      end
    end
  end

  describe "Canvas OAuth connections" do
    it "should fail if no canvas page is defined" do
      Facebooker2.canvas_page_name = nil

      lambda { controller.send(:canvas_oauth_connect) }.should raise_error
    end

    it "should throw an OAuth exception if there was an error in authenticating" do
      controller.stub!(:params).and_return(:error => { :message => 'User denied access.' })

      lambda { controller.send(:canvas_oauth_connect) }.should raise_error(Facebooker2::OAuthException, 'User denied access.')
    end

    it "should throw an OAuth exception if no code is returned" do
      controller.stub!(:params).and_return({})

      lambda { controller.send(:canvas_oauth_connect) }.should raise_error(Facebooker2::OAuthException, 'No code returned.')
    end

    it "should redirect to the canvas application on success" do
      controller.stub!(:params).and_return(:code => '12345')
      controller.expects(:redirect_to).with('http://apps.facebook.com/my-application')
      controller.send(:canvas_oauth_connect)
    end
  end

  describe "Ensuring canvas is connected" do
    describe "with a Symbol for a callback URL" do
      before(:each) do
        FakeCanvasOAuthController._facebooker_oauth_callback_url = :my_url
        FakeCanvasOAuthController._facebooker_scope = %w{permission other}
      end

      it "should render a redirect if none of the three pieces of info are defined" do
        controller.stub!(:current_facebook_user).and_return(nil)
        controller.stub!(:params).and_return({})
        controller.expects(:render).with() { |hash|
          hash[:text][Facebooker2.app_id] != nil &&
          hash[:text]["my url"] != nil &&
          hash[:text]["scope=permission,other"] != nil
        }
      end

      describe "should not render a redirect if" do
        it "a user if found" do
          controller.stub!(:current_facebook_user).and_return(true)
          controller.stub!(:params).and_return({})
          controller.expects(:render).never
        end

        [ :code, :error ].each do |param|
          it "param[:#{param}] exists" do
            controller.stub!(:current_facebook_user).and_return(nil)
            controller.stub!(:params).and_return(param => param)
            controller.expects(:render).never
          end
        end
      end
    end
  end
end
