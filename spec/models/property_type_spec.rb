require File.expand_path("../../spec_helper", __FILE__)

describe PropertyType do
  before :each do
    @property_type = Factory(:property_type)
  end

  it "should have 1 hour collection period by default" do
    @property_type.collect_period.should == 1 # hour
  end

  describe "when calculating upgrade price" do
    it "should return basic price plus cost increase for each additional level" do
      @property_type.upgrade_price(1).should == 1100 # 1000 + 100
      @property_type.upgrade_price(20).should == 3000 # 1000 + 100 * 20
    end

    it "should return basic price if cost increase is not defined" do
      @property_type.upgrade_cost_increase = 0

      @property_type.upgrade_price(2).should == 1000
      @property_type.upgrade_price(20).should == 1000
    end
  end
end