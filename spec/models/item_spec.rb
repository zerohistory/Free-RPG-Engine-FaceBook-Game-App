require 'spec_helper'

describe Item do
  describe 'scopes' do
    before do
      item_group = Factory.create :item_group
      @item_1 = Factory.create :item, :basic_price => 10, :name => 'item_1', :item_group => item_group, :level => 1
      @item_2 = Factory.create :item, :basic_price => 20, :name => 'item_2', :item_group => item_group, :level => 1
      @item_3 = Factory.create :item, :basic_price => 30, :name => 'item_3', :item_group => item_group, :level => 3

      @ctype = Factory.create :character_type
      @character = Factory.create :character, :character_type => @ctype, :level => 1
    end

    it 'should select items, available for character for given level' do
      Item.available_for(@character).all.should == [@item_1, @item_2]
    end
  end

  describe 'when creating' do
    before do
      @item = Factory.build(:item)
    end

    it 'should validate numericality of package size' do
      @item.should validate_numericality_of(:package_size)
    end

    it 'should validate that package size is greater than zero' do
      @item.package_size = 0

      @item.should_not be_valid
    end
  end

  describe 'when getting package size' do
    before do
      @item = Factory(:item)
    end

    it 'should return 1 when package size is not set' do
      @item.package_size.should == 1
    end

    it 'should return value when package size is set' do
      @item.package_size = 5

      @item.package_size.should == 5
    end
  end

  describe 'when checking if item can be sold' do
    before do
      @item = Factory(:item, :can_be_sold => true)
    end

    it 'should return true if flag is set and package size is 1' do
      @item.can_be_sold?.should be_true
    end

    it 'should return false if flag is not set' do
      @item.can_be_sold = false

      @item.can_be_sold?.should be_false
    end

    it 'should return false if package size is larger than 1' do
      @item.package_size = 2

      @item.can_be_sold?.should be_false
    end
  end
end
