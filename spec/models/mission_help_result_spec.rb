require 'spec_helper'

describe MissionHelpResult do
  describe 'associations' do
    before do
      @help_result = MissionHelpResult.new
    end
    
    it 'should belong to character' do
      @help_result.should belong_to(:character)
    end
    
    it 'should belong to requester' do
      @help_result.should belong_to(:requester)
    end
    
    it 'should belong to mission' do
      @help_result.should belong_to(:mission)
    end
  end
  
  describe 'class' do
    describe 'when retreiving character list' do
      before do
        @character1 = Factory(:mission_help_result).character
        @character2 = Factory(:mission_help_result).character
        @character3 = Factory(:mission_help_result, :collected => true).character
      end
      
      it 'should collect characters for help results' do
        MissionHelpResult.characters.should == [@character1, @character2, @character3]
      end
      
      it 'should collect characters by current scope' do
        MissionHelpResult.scoped(:conditions => {:collected => false}).characters.should == [@character1, @character2]
      end
    end
  end
  
  describe 'when creating' do
    before do
      @character  = Factory(:character)
      @requester  = Factory(:character)
      @mission    = Factory(:mission_with_level)
      
      @mission.levels.first.update_attributes(:experience => 200, :money_min => 100, :money_max => 100)
      
      @help_result = @character.mission_help_results.build(:requester => @requester, :mission => @mission)
    end
    
    it 'should successfully save' do
      @help_result.save.should be_true
    end
    
    it 'should give 25% of mission level money to character' do
      @help_result.save
      
      @help_result.basic_money.should == 25
    end
    
    it 'should give 25% of mission level experience to character' do
      @help_result.save
      
      @help_result.experience.should == 50
    end
    
    describe 'when already helped with this mission' do
      before do
        @other_result = Factory.create(:mission_help_result, 
          :mission_id   => @mission.id,   # IDs are used to prevent cascade save of @help_result
          :requester_id => @requester.id, 
          :character_id => @character.id
        )
      end
      
      it 'should fail to save and add error message' do
        @help_result.save.should be_false
        
        @help_result.errors.on(:base).should_not be_empty
        @help_result.errors.on(:base).should =~ /already helped/
      end
    end
    
    describe 'when trying to help themself' do
      before do
        @help_result.requester = @character
      end
      
      it 'should fail to save and add error message' do
        @help_result.save.should be_false
        
        @help_result.errors.on(:base).should_not be_empty
        @help_result.errors.on(:base).should =~ /cannot help yourself/
      end
    end
  end
end