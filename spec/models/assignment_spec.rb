require 'spec_helper'

describe Assignment do
  %w{attack defence fight_damage fight_income mission_energy mission_income}.each do |role|
    describe "when receiving #{role} effect for collection" do
      before do
        @character1 = Factory(:character)
        @character2 = Factory(:character)

        @friend_relation = FriendRelation.create!(:owner => @character1, :character => @character2)
        
        @assignment = @character1.assignments.create!(
          :relation => @friend_relation,
          :role => role
        )
      end

      it "should return assignment effect value if assignment for #{role} exists" do
        Assignment.stub!(:all).and_return([@assignment])
        
        Assignment.send("#{role}_effect").should == 1
      end
      
      it "should return 0 if there is no assignment for #{role}" do
        Assignment.stub!(:all).and_return([])

        Assignment.send("#{role}_effect").should == 0
      end
    end
  end
end