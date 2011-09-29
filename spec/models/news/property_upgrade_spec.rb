require 'spec_helper'

describe News::PropertyUpgrade do
  describe 'when getting level' do
    before do
      @property = Factory(:property)
      @news = News::PropertyUpgrade.create(:character => Factory(:character), :data => {:property_id => @property.id, :level => 3})
    end
    
    it 'should return level value from data' do
      @news.level.should == 3
    end
    
    it 'should return current property level if there is no level data' do
      @news.data[:level] = nil
      
      @news.level.should == 1
    end
  end
end