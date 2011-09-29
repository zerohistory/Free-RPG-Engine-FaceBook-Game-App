require 'spec_helper'

describe StoriesController do
  before do
    controller.stub!(:current_facebook_user).and_return(fake_fb_user)
  end
  
  describe "when routing" do
    it "should correctly map to story page" do
      params_from(:get, "/stories/asd123").should == {
        :controller => "stories",
        :action     => "show",
        :id         => "asd123"
      }
    end
  end
  
  describe 'when visiting story' do
    before do
      @character = mock_model(Character)

      controller.stub!(:current_character).and_return(@character)

      @story = mock_model(Story, 
        :alias => 'somealias', 
        :track_visit! => []
      )
      
      @story_data = 'drDaHHyJrkDUN6vc5j6iTg4Qqj5mkwp93nEsCh3x/1w=--b7T0SRHS2i4vPs1MSU+txg==' # {:character_id => 1}
    end
    
    def do_request(options = {})
      get(:show, options.reverse_merge(:id => 123, :story_data => @story_data))
    end

    def do_broken_request(options = {})
      get(:show, options.reverse_merge(:id => 123, 'amp;story_data' => @story_data))
    end
    
    it 'should try to fetch story from the database' do
      Story.should_receive(:find_by_id).with('123').and_return(@story)
      
      do_request
    end
    
    describe 'when there is a story with given ID' do
      before do
        Story.stub!(:find_by_id).and_return(@story)
      end
      
      it 'should track character\'s visit to the story' do
        @story.should_receive(:track_visit!).with(@character, :character_id => 1).and_return([])
        
        do_request
      end
      
      describe 'if visit tracking gave some payouts' do
        before do
          @payouts = Payouts::Collection.new(DummyPayout.new)
          
          @story.stub!(:track_visit!).and_return(@payouts)
        end
        
        it 'should display a page with story payout results' do
          do_request
          
          response.should render_template(:show)
        end
        
        it 'should pass story to the template' do
          do_request
          
          assigns[:story].should == @story
        end
        
        it 'should pass next page url to the template' do
          do_request
          
          assigns[:next_page].should == 'http://apps.facebook.com/test/'
        end
        
        it 'should pass payouts to the template' do
          do_request
          
          assigns[:payouts].should == @payouts
        end
      end

      it 'should redirect to next page if there were no payouts' do
        do_request
        
        response.should redirect_from_iframe_to('http://apps.facebook.com/test/')
      end
    end
    
    describe 'when ID is a default story alias' do
      it 'should target to home page from level up story' do
        do_request :id => 'level_up'
        
        response.should redirect_from_iframe_to('http://apps.facebook.com/test/')
      end
      
      it 'should target to shop page from inventory story' do
        do_request :id => 'item_purchased'
        
        response.should redirect_from_iframe_to('http://apps.facebook.com/test/items')
      end
      
      it 'should target to mission help page from mission help request story' do
        controller.send(:encryptor).should_receive(:encrypt).with(:mission_id => 1, :character_id => 1).and_return('securehelpkey')
        
        do_request(
          :id => 'mission_help',
          :story_data => 'MGkvJJvNnYLx4AdeLp+K2rGBbn75MUMmhs9iFolovvIbTPO49ivKMpb4R+1mqTQA--5i8CyrzRPaYSvpRZnkh2oQ==' # {:mission_id => 1, :character_id => 1}
        )

        response.should redirect_from_iframe_to('http://apps.facebook.com/test/missions/1/help?key=securehelpkey')
      end
      
      it 'should target to mission group page from mission completion story' do
        Mission.should_receive(:find).with(1).and_return(mock_model(Mission, :mission_group_id => 2))
        
        do_request(
          :id => 'mission_completed',
          :story_data => 'MGkvJJvNnYLx4AdeLp+K2rGBbn75MUMmhs9iFolovvIbTPO49ivKMpb4R+1mqTQA--5i8CyrzRPaYSvpRZnkh2oQ==' # {:mission_id => 1, :character_id => 1}
        )

        response.should redirect_from_iframe_to('http://apps.facebook.com/test/mission_groups/2')
      end
      
      it 'should target to mission group page from boss story' do
        Boss.should_receive(:find).with(1).and_return(mock_model(Boss, :mission_group_id => 2))

        do_request(
          :id => 'boss_defeated',
          :story_data => 'NCipKIRIkYNlRxDfS7o6QWdydL+Un0/q0e1Q8m9Szkk=--z/LNV+JvdEEClxpkPapxIw==' # {:boss_id => 1, :character_id => 1}
        )

        response.should redirect_from_iframe_to('http://apps.facebook.com/test/mission_groups/2')
      end
      
      it 'should target to monster page from monster invitation story' do
        controller.send(:encryptor).should_receive(:encrypt).with(1).and_return('securemonsterkey')
        
        do_request(
          :id => 'monster_invite',
          :story_data => 'cMKj+S40uXVpaez9dt6pGwIyDk76SM0HcjIGYO2RDKgl3oEc/sANp0IGq5G1xmrh--7lGcWvHmmnyuVjkrRGCrVg==' # {:monster_id => 1, :character_id => 1}
        )

        response.should redirect_from_iframe_to('http://apps.facebook.com/test/monsters/1?key=securemonsterkey')
      end
      
      it 'should target to monster page from monster defeat story' do
        controller.send(:encryptor).should_receive(:encrypt).with(1).and_return('securemonsterkey')
        
        do_request(
          :id => 'monster_defeated',
          :story_data => 'cMKj+S40uXVpaez9dt6pGwIyDk76SM0HcjIGYO2RDKgl3oEc/sANp0IGq5G1xmrh--7lGcWvHmmnyuVjkrRGCrVg==' # {:monster_id => 1, :character_id => 1}
        )

        response.should redirect_from_iframe_to('http://apps.facebook.com/test/monsters/1?key=securemonsterkey')
      end
      
      it 'should target to property list page from property purchase story' do
        do_request(:id => 'property')
        
        response.should redirect_from_iframe_to('http://apps.facebook.com/test/properties')
      end
      
      it 'should target to promotion page from promotion story' do
        Promotion.should_receive(:find).with(123).and_return(mock_model(Promotion, :to_param => 'asd123'))
        
        do_request(
          :id => 'promotion',
          :story_data => 'WQABey+hEPYwdKsLFWQBFiJfiDrT3sG3RaTA01EM/awLcCpdhPfEHPvW5VAoJBV5--VVYB4eZIDO9zTEu989SUAA==' # {:promotion_id => 123, :character_id => 1}
        )
        
        response.should redirect_from_iframe_to('http://apps.facebook.com/test/promotions/asd123')
      end
      
      it 'should target to hitlist page from new hit listing story' do
        do_request :id => 'hit_listing_new'
        
        response.should redirect_from_iframe_to('http://apps.facebook.com/test/hit_listings')
      end
      
      it 'should target to hitlist page from completed hit listing story' do
        do_request :id => 'hit_listing_completed'
        
        response.should redirect_from_iframe_to('http://apps.facebook.com/test/hit_listings')
      end
      
      it 'should target to collection list page from collection completion story' do
        do_request :id => 'collection_completed'
        
        response.should redirect_from_iframe_to('http://apps.facebook.com/test/item_collections')
      end
      
      it 'should target to item giveout page from missing collection items story' do
        controller.send(:encryptor).should_receive(:encrypt).with(
          :items => [1, 2, 3],
          :valid_till => Time.parse('Tue Jan 25 14:18:45 +0500 2011'),
          :character_id => 1
        ).and_return('securegiveoutkey')
        
        do_request(
          :id => 'collection_missing_items',
          :story_data => 'm5d9l+fZpUwLYpn9NuO9aPzaiajMlLJHvyaq9IKq7iHGeWCWwyL/YVKS+OYq5FXXcm83Rolax7XuXCEZPQxnN7FLsdcpxabkzPztnXwLPzkahs+hXl5LvWuHl4TNOz/z--2zGXLYZmoG+CiuQItb5v0w=='
          # {:items => [1,2,3], :valid_till => Time.parse('Tue Jan 25 14:18:45 +0500 2011'), :character_id => 1}
        )
        
        response.should redirect_from_iframe_to('http://apps.facebook.com/test/inventories/give?request_data=securegiveoutkey')
      end
    end
    
    it 'should redirect to root on invalid story data' do
      lambda{
        do_request(:story_data => 'this is just wrong')
      }.should_not raise_exception
      
      response.should redirect_from_iframe_to('http://apps.facebook.com/test/')
    end
    
    it 'should be able to process story links broken by facebook encoding' do
      lambda{
        do_broken_request :id => 'item_purchased'
      }.should_not raise_exception
      
      response.should redirect_from_iframe_to('http://apps.facebook.com/test/items')
    end
  end
end