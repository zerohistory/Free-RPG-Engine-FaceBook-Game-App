require 'spec_helper'

describe HitListingsController do
  before do
    controller.stub!(:current_facebook_user).and_return(fake_fb_user)
  end
  
  describe "when routing" do
    it "should map GET /hit_listings to a hitlist page" do
      params_from(:get, "/hit_listings").should == {
        :controller   => "hit_listings",
        :action       => "index"
      }
    end

    it "should map GET /characters/123/hit_listings/new to a new hit listing page" do
      params_from(:get, "/characters/123/hit_listings/new").should == {
        :controller   => "hit_listings",
        :action       => "new",
        :character_id => "123"
      }
    end

    it "should map POST /characters/123/hit_listings to a hit listing creation page" do
      params_from(:post, "/characters/123/hit_listings").should == {
        :controller   => "hit_listings",
        :action       => "create",
        :character_id => "123"
      }
    end

    it "should map PUT /hit_listings/123 to a hit listing attack page" do
      params_from(:put, "/hit_listings/123").should == {
        :controller => "hit_listings",
        :action     => "update",
        :id         => "123"
      }
    end
  end

  describe "routing helpers" do
    it "should have helper for hitlist page" do
      hit_listings_path.should == "/hit_listings"
    end

    it "should have helper for new hit listing page" do
      new_character_hit_listing_path(123).should == "/characters/123/hit_listings/new"
    end

    it "should have helper for character hit listings page" do
      character_hit_listings_path(123).should == "/characters/123/hit_listings"
    end

    it "should have helper for a hit listing page" do
      hit_listing_path(123).should == "/hit_listings/123"
    end
  end

  shared_examples_for "fetching available listings" do
    before :each do
      @hit_listings = mock("listings")
      @character_listings = mock("available for character", :paginate => @hit_listings)
      @incomplete_listings = mock("incomplete", :available_for => @character_listings)

      HitListing.stub!(:incomplete).and_return(@incomplete_listings)
    end

    it "should fetch available listings" do
      @incomplete_listings.should_receive(:available_for).and_return(@character_listings)

      do_request
    end

    it "should paginate listings" do
      @character_listings.should_receive(:paginate)

      do_request
    end

    it "should pass available listings to the template" do
      do_request

      assigns[:hit_listings].should == @hit_listings
    end
  end

  describe "when displaying hitlist" do
    before :each do
      controller.stub!(:current_character).and_return(mock_model(Character))
    end

    def do_request
      get :index
    end

    it_should_behave_like "fetching available listings"

    it "should render 'index'" do
      do_request

      response.should render_template(:index)
    end
  end

  describe "when listing a character" do
    before :each do
      @hit_listing = mock_model(HitListing)
      @client_hit_listings = mock("hit_listings", :build => @hit_listing)
      @client = mock_model(Character, :ordered_hit_listings => @client_hit_listings)

      controller.stub!(:current_character).and_return(@client)

      @victim = mock_model(Character)

      Character.stub!(:find).and_return(@victim)
    end
    
    def do_request
      get :new, :character_id => 123
    end

    it "should fetch victim from the database" do
      Character.should_receive(:find).with("123").and_return(@victim)

      do_request
    end

    it "should create a hit listing for the character" do
      @client_hit_listings.should_receive(:build).with(:victim => @victim, :reward => 10_000).and_return(@hit_listing)

      do_request
    end

    it "should pass the victim to the template" do
      do_request

      assigns[:victim].should == @victim
    end

    it "should pass the listing to the template" do
      do_request

      assigns[:hit_listing].should == @hit_listing
    end

    it "should render 'new'" do
      do_request

      response.should render_template(:new)
    end
  end

  describe "when saving new hit listing" do
    before :each do
      @hit_listing = mock_model(HitListing, :save => true)
      @client_hit_listings = mock("hit_listings", :build => @hit_listing)
      @client = mock_model(Character, :ordered_hit_listings => @client_hit_listings)

      controller.stub!(:current_character).and_return(@client)

      @victim = mock_model(Character, :id => 123)

      Character.stub!(:find).and_return(@victim)
    end

    def do_request
      post :create, :character_id => 123, :hit_listing => {:reward => 10_000}
    end

    it "should fetch victim from the database" do
      Character.should_receive(:find).with("123").and_return(@victim)

      do_request
    end
    
    it "should build new hit listing for current character" do
      @client_hit_listings.should_receive(:build).with(:victim => @victim, :reward => 10_000).and_return(@hit_listing)

      do_request
    end
    
    it "should try to save the hit listing" do
      @hit_listing.should_receive(:save).and_return(true)

      do_request
    end

    it "should pass victim to the template" do
      do_request

      assigns[:victim].should == @victim
    end

    it "should pass listing to the template" do
      do_request

      assigns[:hit_listing].should == @hit_listing
    end

    describe "if the listing was created successfully" do
      it_should_behave_like "fetching available listings"

      it "should render 'create'" do
        do_request

        response.should render_template(:create)
      end
    end

    describe "if the listing wasn't created" do
      before :each do
        @hit_listing.stub!(:save).and_return(false)
      end

      it "should render 'new'" do
        do_request

        response.should render_template(:new)
      end
    end
  end

  describe "when attacking hitlisted victim" do
    before :each do
      @result = mock_model(Fight)

      @hit_listing = mock_model(HitListing, :execute! => @result, :completed? => false)

      HitListing.stub!(:find).and_return(@hit_listing)

      @attacker = mock_model(Character)

      controller.stub!(:current_character).and_return(@attacker)
    end

    def do_request
      put :update, :id => 123
    end

    it "should fetch listing from the database" do
      HitListing.should_receive(:find).with("123").and_return(@hit_listing)

      do_request
    end

    it "should execute listing" do
      @hit_listing.should_receive(:execute!).with(@attacker).and_return(@result)

      do_request
    end

    it "should pass listing to the template" do
      do_request

      assigns[:hit_listing].should == @hit_listing
    end
    
    it "should pass result to the template" do
      do_request

      assigns[:fight].should == @result
    end

    it "should render AJAX response" do
      do_request

      response.should render_template(:update)
      response.should use_layout(:ajax)
    end

    describe "when listing is completed" do
      before :each do
        @hit_listing.stub!(:completed?).and_return(true)
      end

      it_should_behave_like "fetching available listings"
    end
  end
end