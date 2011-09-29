require 'spec_helper'

describe Character do
  describe 'friend_relations' do
    describe '#establish!' do
      before do
        @character = Factory(:character)
        @target = Factory(:character)
      end
      
      it 'should create relations between character and target' do
        lambda{
          @character.friend_relations.establish!(@target)
        }.should change(FriendRelation, :count).by(2)
        
        @character.friend_relations.first.character.should  == @target
        @target.friend_relations.first.character.should     == @character
      end
    end
  end
end