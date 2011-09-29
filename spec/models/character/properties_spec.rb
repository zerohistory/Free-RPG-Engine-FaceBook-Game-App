require File.expand_path("../../../spec_helper", __FILE__)

describe Character do
  before :each do
    @property_type = Factory(:property_type)
    
    @character = Factory(:character, :basic_money => 1100)

    @property1 = Factory(:property)
    @property2 = Factory(:property)
  end

  describe "when giving a property" do
    describe "if user doesn't have this property" do
      it "should add property" do
        lambda{
          @character.properties.give!(@property_type)
        }.should change(@character.properties, :count).from(0).to(1)
      end
    end

    describe "if user already has this property" do
      before :each do
        @character.properties.create(:property_type => @property_type)
      end

      it "shouldn't add property" do
        lambda{
          @character.properties.give!(@property_type)
        }.should_not change(@character.properties, :count)
      end
    end

    it "should return an instance of Property class" do
      @character.properties.give!(@property_type).should be_instance_of(Property)
    end
  end

  describe "when buying properties" do
    describe "if the property doesn't exist" do
      it "should add a property to user" do
        lambda{
          @character.properties.buy!(@property_type)
        }.should change(@character.properties, :count)
      end
    end

    describe "if the property already exist" do
      before :each do
        @character.properties.create(:property_type => @property_type)
      end

      it "shouldn't add a property to user" do
        lambda{
          @character.properties.buy!(@property_type)
        }.should_not change(@character.properties, :count)
      end
    end

    it "should return an instance of Property class" do
      @character.properties.buy!(@property_type).should be_instance_of(Property)
    end
  end

  describe "when collecting money from properties" do
    before :each do
      # Make property 2 collectable
      @property2.update_attribute(:collected_at, 61.minutes.ago)

      @character.properties = [@property1, @property2]
    end

    it "should collect money for each property" do
      @property1.should_receive(:collect_money!).and_return(Payouts::Collection.new)
      @property2.should_receive(:collect_money!).and_return(Payouts::Collection.new)

      @character.properties.collect_money!
    end

    it "should return sum of all collected money" do
      @character.properties.collect_money!.should be_kind_of(Payouts::Collection)
    end

    it "should return false if collected nothing" do
      @property2.update_attribute(:collected_at, Time.now)

      @character.properties.collect_money!.should be_false
    end
  end

  describe "when getting a list of collectable properties" do
    before :each do
      @character.properties = [@property1, @property2]
    end

    it "should return empty array if there is no collectable properties" do
      @character.properties.collectable.size.should == 0
    end

    it "should return only collectable properties" do
      # Make property 2 collectable
      @property2.update_attribute(:collected_at, 61.minutes.ago)

      @character.properties.collectable.size.should == 1
      @character.properties.collectable.should include(@property2)
    end
  end
end

