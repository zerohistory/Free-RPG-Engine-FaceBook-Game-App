require File.expand_path("../../spec_helper", __FILE__)

describe InventoriesController do
  before do
    controller.stub!(:current_facebook_user).and_return(fake_fb_user)
  end
  
  describe "when routing" do
    it "should correctly map to inventory usage for a single inventory" do
      params_from(:post, "/inventories/123/use").should == {
        :controller => "inventories",
        :action     => "use",
        :id         => "123"
      }
    end
  end

  describe "when using inventory" do
    before :each do
      @usage_result = Payouts::Collection.new
      @inventory = mock_model(Inventory, :use! => @usage_result)

      @character_inventories = mock(:inventories, :find => @inventory)
      @character = mock_model(Character, :inventories => @character_inventories)

      controller.stub!(:current_character).and_return(@character)
    end

    it "should fetch inventory from current character by ID" do
      @character_inventories.should_receive(:find).with("123").and_return(@inventory)

      post :use, :id => 123
    end

    it "should use the inventory" do
      @inventory.should_receive(:use!).and_return(@usage_result)

      post :use, :id => 123
    end

    it "should pass usage result to the template" do
      post :use, :id => 123
      
      assigns[:result].should == @usage_result
    end

    it "should render AJAX response" do
      post :use, :id => 123

      response.should render_template("use")
      response.should use_layout("ajax")
    end
  end
end