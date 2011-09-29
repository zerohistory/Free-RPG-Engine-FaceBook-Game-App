require 'spec_helper'

describe HitListing do
  describe "scopes" do
    it "should have 'incomplete' scope to display only incomplete listings" do
      @complete_listing   = Factory(:hit_listing, :completed => true)
      @incomplete_listing = Factory(:hit_listing)

      HitListing.incomplete.all.should include(@incomplete_listing)
      HitListing.incomplete.all.should_not include(@complete_listing)
    end
  end

  describe "when creating" do
    before :each do
      @hit_listing = Factory.build(:hit_listing)
    end
    
    describe "when valid" do
      it "should be saved successfully" do
        lambda{
          @hit_listing.save!.should be_true
        }.should change(HitListing, :count).from(0).to(1)
      end

      it "should charge client for reward amount" do
        lambda{
          @hit_listing.save!
        }.should change(@hit_listing.client, :basic_money).from(10_000).to(0)
      end

      it "should get a defined fee from the reward" do
        lambda{
          @hit_listing.save!
        }.should change(@hit_listing, :reward).from(10_000).to(8_000)
      end
    end

    it "should not be valid without a client" do
      @hit_listing.client = nil

      @hit_listing.should_not be_valid

      @hit_listing.errors.on(:client).should_not be_empty
    end

    it "should not be valid without a victim" do
      @hit_listing.victim = nil

      @hit_listing.should_not be_valid

      @hit_listing.errors.on(:victim).should_not be_empty
    end

    it "should not be valid without a reward" do
      @hit_listing.reward = nil

      @hit_listing.should_not be_valid

      @hit_listing.errors.on(:reward).should_not be_empty
    end

    it "should not be valid when reward is below the minumum value" do
      @hit_listing.reward = 9_999

      @hit_listing.should_not be_valid

      @hit_listing.errors.on(:reward).should_not be_empty
    end

    it "should not be valid when client doesn't have enough money" do
      @hit_listing.client.basic_money = 9_999

      @hit_listing.should_not be_valid

      @hit_listing.errors.on(:reward).should_not be_empty
    end

    it "should not be valid if victim is weak" do
      @hit_listing.victim.stub!(:weak?).and_return(true)

      @hit_listing.should_not be_valid

      @hit_listing.errors.on(:victim).should_not be_empty
    end

    it "should not be valid if victim is already listed" do
      @other_listing = Factory(:hit_listing, :victim => @hit_listing.victim)

      @hit_listing.should_not be_valid

      @hit_listing.errors.on(:victim).should_not be_empty
    end
    
    it 'should not be valid is victim was listed less than 12 hours ago' do
      @other_listing = Factory(:hit_listing, :victim => @hit_listing.victim, :completed => true, :executor => Factory(:character))
      HitListing.update_all({:updated_at => (12.hours - 1.minute).ago}, {:id => @other_listing.id})
      
      @hit_listing.should_not be_valid
      @hit_listing.errors.on(:victim).should_not be_empty
    end
  end

  describe "when executing a listing" do
    before :each do
      @attacker = Factory(:character)
      @victim = Factory(:character)

      @hit_listing = Factory(:hit_listing, :victim => @victim)
    end

    it "should create a fight basing on attacker, victim, and using listing as cause" do
      lambda{
        @hit_listing.execute!(@attacker)
      }.should change(Fight, :count).from(0).to(1)

      fight = Fight.first

      fight.attacker.should == @attacker
      fight.victim.should   == @victim
      fight.cause.should    == @hit_listing
    end

    it "should return a saved fight" do
      result = @hit_listing.execute!(@attacker)

      result.should be_kind_of(Fight)
      
      result.should_not be_new_record
    end

    describe "if victim has zero health" do
      before :each do
        @victim.hp = 0
      end

      it "should assign attacker as executor" do
        lambda{
          @hit_listing.execute!(@attacker)
        }.should change(@hit_listing, :executor).from(nil).to(@attacker)
      end

      it "should give a reward to attacker" do
        @fight = mock_model(Fight, :winner_award => 0, :save => true)

        Fight.should_receive(:new).and_return(@fight)
        
        lambda{
          @hit_listing.execute!(@attacker)
        }.should change(@attacker, :basic_money).by(8000)
      end

      it "should mark listing as completed" do
        lambda{
          @hit_listing.execute!(@attacker)
        }.should change(@hit_listing, :completed).from(false).to(true)
      end

      it "should save chnages to attacker" do
        @hit_listing.execute!(@attacker)

        @attacker.should_not be_changed
      end

      it "should save changes to listing" do
        @hit_listing.execute!(@attacker)

        @hit_listing.should_not be_changed
      end
    end

    describe "if fight wasn't saved for some reason" do
      before :each do
        @fight = mock_model(Fight, :save => false)

        Fight.stub!(:new).and_return(@fight)
      end

      it "shouldn't check victim health" do
        @victim.should_not_receive(:hp)

        @hit_listing.execute!(@attacker)
      end

      it "should return unsaved fight" do
        @hit_listing.execute!(@attacker).should == @fight
      end
    end

    describe "if listing is already completed" do
      before :each do
        @hit_listing.completed = true
      end

      it "should return false" do
        @hit_listing.execute!(@attacker).should be_false
      end
      
      it "shouldn't try to create a fight" do
        Fight.should_not_receive(:create)

        @hit_listing.execute!(@attacker)
      end
      
      it 'should add completed listing error' do
        @hit_listing.execute!(@attacker)
        
        @hit_listing.errors.should_not be_empty
        @hit_listing.errors.on(:base).should =~ /Somebody already took out this target before you got the chance/
      end
    end
    
    describe 'if client tries to complete his own listing' do
      before do
        @hit_listing.client = @attacker
      end
      
      it 'should return false' do
        @hit_listing.execute!(@attacker).should be_false
      end
      
      it 'shouldn\'t try to save fight' do
        Fight.should_not_receive(:create)
        
        @hit_listing.execute!(@attacker)
      end
      
      it 'should add client attack error' do
        @hit_listing.execute!(@attacker)
        
        @hit_listing.errors.should_not be_empty
      end
    end
  end
end