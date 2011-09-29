require 'spec_helper'

describe Story do
  describe 'defaults' do
    it 'should be hidden by default' do
      Story.new.should be_hidden
    end
    
    it 'should have attachment' do
      Story.new.should have_attached_file(:image)
    end
  end
  
  describe 'scopes' do
    describe 'when finding by alias' do
      before do
        @story1 = Factory(:story)
        @story2 = Factory(:story)
        @story3 = Factory(:story)
        @story4 = Factory(:story, :alias => 'nonmatchingalias')
      
        @story1.publish
        @story2.publish
      end
    
      it 'should find visible stories only' do
        Story.by_alias('level_up').should_not include(@story3)
      end
    
      it 'should find stories with matching alias' do
        Story.by_alias('level_up').should_not include(@story4)
      end
    
      it 'should order stories randomly' do
        Story.by_alias('level_up').proxy_options[:order].should =~ /RAND\(\)/
      end
    
      it 'should work with symbols as well as with strings' do
        Story.by_alias(:level_up).should include(@story1, @story2)
      end
    end
  end
  
  describe 'when creating' do
    before do
      @story = Factory.build(:story)
    end
    
    %w{alias title description action_link}.each do |attribute|
      it "should require #{attribute} to be set" do
        @story.should validate_presence_of(attribute)
      end
    end

    it 'should successfully save' do
      @story.save.should be_true
    end
  end
  
  describe 'when interpolating attributes' do
    before do
      @story = Factory(:story, 
        :title => 'This is title with %{value}', 
        :description => 'This is description with %{value}'
      )
    end
    
    describe 'when interpolating single attribute' do
      it 'should raise exception when passed unallowed attribute value' do
        lambda {
          @story.interpolate(:state)
        }.should raise_exception(ArgumentError)
      end
    
      %w{title description action_link payout_message}.each do |attribute|
        it "should successfully interpolate #{attribute}" do
          @story[attribute] = 'Text with %{value}'
        
          @story.interpolate(attribute, :value => 123).should == 'Text with 123'
        end
      end
    
      it 'should return nil when attribute is blank' do
        @story.description = ''
      
        @story.interpolate(:description, :value => "asd").should be_nil
      end
    
      it 'should insert passed value into text' do
        @story.interpolate(:title, :value => 123).should == 'This is title with 123'
      end
    end
    
    describe 'when interpolating an array of attributes' do
      it 'should return an array of texts with inserted values' do
        @story.interpolate([:title, :description], :value => 123).should == ['This is title with 123', 'This is description with 123']
      end
    end
  end
  
  describe 'when tracking story visit' do
    before do
      @character = Factory(:character)
      @story = Factory(:story, :payouts => Payouts::Collection.new(DummyPayout.new(:apply_on => :visit)))
    end
    
    it 'should create story visit record for current character, story type, and story reference' do
      lambda{
        @story.track_visit!(@character, :level => 1)
      }.should change(StoryVisit, :count).from(0).to(1)
    end
    
    it 'should apply payouts to character' do
      @story.track_visit!(@character, :level => 1)
      
      @story.payouts.first.should be_applied
    end
    
    it 'should return payout result' do
      result = @story.track_visit!(@character, :level => 1)
      
      result.should be_kind_of(Payouts::Collection)
      result.first.should be_applied
    end
    
    describe 'when story is already visited' do
      before do
        StoryVisit.create!(:character_id => @character.id, :story_alias => @story.alias, :reference_id => 1)
      end
      
      it 'should not create visit record' do
        lambda{
          @story.track_visit!(@character, :level => 1)
        }.should_not change(StoryVisit, :count)
      end
      
      it 'should not apply payouts' do
        lambda{
          @story.track_visit!(@character, :level => 1)
        }.should_not change(@story.payouts.first, :applied?)
      end
      
      it 'should return empty array' do
        @story.track_visit!(@character, :level => 1).should == []
      end
    end
    
    {
      'level_up'                  => :level,
      'item_purchased'            => :item_id,
      'mission_help'              => :mission_id,
      'mission_completed'         => :mission_id,
      'boss_defeated'             => :boss_id,
      'monster_invite'            => :monster_id,
      'monster_defeated'          => :monster_id,
      'property'                  => :property_id,
      'promotion'                 => :promotion_id,
      'hit_listing_new'           => :hit_listing_id,
      'hit_listing_completed'     => :hit_listing_id,
      'collection_completed'      => :collection_id,
      'collection_missing_items'  => :collection_id
    }.each do |story_type, reference|      
      it "should give payouts for different #{reference} in #{story_type} story" do
        @story.alias = story_type
      
        @story.track_visit!(@character, reference => 1).should_not be_empty
        @story.track_visit!(@character, reference => 1).should be_empty
        @story.track_visit!(@character, reference => 2).should_not be_empty
      end
    end      
  end
  
  describe 'when fetching scope name' do
    before do
      @story = Factory(:story)
    end
    
    it 'should return story alias and ID' do
      @story.name.should == "Story ##{@story.id} (level_up)"
    end
  end
end