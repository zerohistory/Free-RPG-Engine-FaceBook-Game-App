require "spec_helper"

describe Character do
  it "should have many ordered hit listings" do
    Character.reflections[:ordered_hit_listings].should_not be_nil
    Character.reflections[:ordered_hit_listings].macro.should == :has_many
    Character.reflections[:ordered_hit_listings].options[:class_name].should == "HitListing"
  end
end