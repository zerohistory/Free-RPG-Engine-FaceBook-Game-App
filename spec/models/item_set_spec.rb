require 'spec_helper'

describe ItemSet do
  describe 'when creating' do
    before do
      @item_set = Factory.build(:item_set)
    end

    it 'should validate presence of name' do
      @item_set.should validate_presence_of(:name)
    end

    it 'should validate presence of at least one item' do
      @item_set.items = []

      @item_set.should_not be_valid
      @item_set.errors.on(:items).should_not be_empty
    end
  end

  describe 'when fetching item list' do
    before do
      @item_set = Factory(:item_set)
    end

    it 'should return empty array when item_ids is blank' do
      @item_set.item_ids = nil

      @item_set.items.should == []
    end

    it 'should return array of items with frequency' do
      @item_set.items.should be_kind_of(Array)

      @item_set.items.first.should == [Item.first, 70]
    end
  end

  describe 'when assigning item list' do
    before do
      @item = Factory(:item)

      @item_set = ItemSet.new
    end

    it 'should railse ArgumentError when passed argument is not hash or array or nil' do
      lambda{ @item_set.items = 'string' }.should raise_exception(ArgumentError)
      lambda{ @item_set.items = @item }.should raise_exception(ArgumentError)
    end

    it 'should drop item cache' do
      @item_set = Factory(:item_set)

      lambda{
        @item_set.items = nil
      }.should change(@item_set, :items)
    end

    describe 'when passing params hash as argument' do
      before do
        @value = {"123" => {"frequency" => 10, "item_id" => @item.id.to_s}}
      end

      it 'should not fail' do
        lambda{
          @item_set.items = @value
        }.should_not raise_exception
      end

      it 'should store an array of item IDs and frequencies as JSON to item_ids attribute' do
        lambda{
          @item_set.items = @value
        }.should change(@item_set, :item_ids).from(nil).to("[[#{@item.id},10]]")
      end
    end

    describe 'when passing array of item IDs and frequencies as argument' do
      before do
        @value = [[@item.id, 10]]
      end

      it 'should not fail' do
        lambda{
          @item_set.items = @value
        }.should_not raise_exception
      end

      it 'should store an array of item IDs and frequencies as JSON to item_ids attribute' do
        lambda{
          @item_set.items = @value
        }.should change(@item_set, :item_ids).from(nil).to("[[#{@item.id},10]]")
      end
    end

    describe 'when passing array of items and frequencies as argument' do
      before do
        @value = [[@item, 10]]
      end

      it 'should not fail' do
        lambda{
          @item_set.items = @value
        }.should_not raise_exception
      end

      it 'should store an array of item IDs and frequencies as JSON to item_ids attribute' do
        lambda{
          @item_set.items = @value
        }.should change(@item_set, :item_ids).from(nil).to("[[#{@item.id},10]]")
      end
    end
  
    describe 'when passing nil as argument' do
      before do
        @item_set = Factory(:item_set)
        @value = nil
      end

      it 'should not fail' do
        lambda{
          @item_set.items = @value
        }.should_not raise_exception
      end

      it 'should clean item_ids attribute' do
        lambda{
          @item_set.items = @value
        }.should change(@item_set, :item_ids).to(nil)
      end
    end
  end

  describe 'when fetching random item' do
    before do
      @item1 = Factory(:item)
      @item2 = Factory(:item)

      @item_set = Factory(:item_set)
      @item_set.items = [[@item1, 70], [@item2, 30]]
    end

    it 'should return an item' do
      @item_set.random_item.should be_kind_of(Item)
    end

    it 'should always return first item if there is only one item' do
      only_item = Factory(:item)

      @item_set.items = [[only_item, 0]]

      @item_set.random_item.should == only_item
    end

    it 'should choose first item basing on its frequency' do
      @item_set.stub!(:rand).and_return(6999)
      @item_set.random_item.should == @item1
    end

    it 'should choose second item basing on its frequency' do
      @item_set.stub!(:rand).and_return(7000)
      @item_set.random_item.should == @item2
    end

    it 'should raise exception when item list is empty' do
      @item_set = ItemSet.new

      lambda{
        @item_set.random_item
      }.should raise_exception
    end

    describe 'when shift value is passed' do
      it 'should shift result' do
        @item_set.stub!(:rand).and_return(6999)
        @item_set.random_item(1).should == @item2
      end

      it 'should correctly return to beginning if shifted outside of the list' do
        @item_set.stub!(:rand).and_return(6999)
        @item_set.random_item(6).should == @item1
      end
    end
  end

  describe 'when receiving item set size' do
    before do
      @item1 = Factory(:item)
      @item2 = Factory(:item)

      @item_set = Factory(:item_set)
      @item_set.items = [[@item1, 70], [@item2, 30]]
    end

    it 'should return number of items in set' do
      @item_set.size.should == 2
    end
  end
end