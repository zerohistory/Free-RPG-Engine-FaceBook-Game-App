require 'spec_helper'

describe StoryVisit do
  describe 'associations' do
    before do
      @story_visit = StoryVisit.new
    end
    
    it 'should belong to character' do
      @story_visit.should belong_to(:character)
    end
  end
end