require 'spec_helper'

describe Character::Equipment do
  describe '#effect' do
    before do
      @character  = Factory(:character)
      @item       = Factory(:item, :attack => 1, :defence => 2)
      @inventory  = Factory(:inventory, :item => @item, :character => @character)
      
      @character.equipment.auto_equip!(@inventory)
      
      @cache = mock('cache', :read => {:attack => 123}, :write => true)
      @character.equipment.instance_variable_set(:@cache, @cache)

        
      @character.equipment.stub!(:inventories).and_return([@inventory])
    end
    
    it 'should try to read cached values from Rails cache' do
      @cache.should_receive(:read).and_return({})
      
      @character.equipment.effect(:attack)
    end
    
    describe 'when cache is empty' do
      before do
        @cache.stub!(:read).and_return(nil)
      end
      
      it 'should collect all effects from equipped inventories' do
        %w{attack defence health energy stamina}.each do |attribute|
          @inventory.should_receive(attribute).and_return(1)
        end
        
        @character.equipment.effect(:attack)
      end
      
      it 'should store collected values to cache for 15 minutes' do
        @cache.should_receive(:write).with(
          "character_#{ @character.id }_equipment_effects", 
          {:attack => 0, :defence => 1, :health => 2, :energy => 3, :stamina => 4}, 
          {:expire_in => 15.minutes}
        )

        %w{attack defence health energy stamina}.each_with_index do |attribute, index|
          @inventory.stub!(attribute).and_return(index)
        end
        
        @character.equipment.effect(:attack)
      end

      it 'should not re-collect effects' do
        @inventory.should_receive(:attack).once
        
        @character.equipment.effect(:attack)
        @character.equipment.effect(:attack)
      end
    end
    
    it 'should return value of the requested effect' do
      @character.equipment.effect(:attack).should == 123
    end
  end
  
  
  describe '#inventories' do
    before do
      @character = Factory(:character)
      @inventory1 = Factory(:inventory, :character => @character)
      @inventory2 = Factory(:inventory, :character => @character)

      
      @character.placements = {
        :additional => [@inventory1.id, @inventory2.id], 
        :left_hand  => [@inventory1.id],
        :right_hand => [@inventory2.id]
      }
    end
    
    it 'should find inventories by IDs stored in placements' do
      Inventory.should_receive(:find_all_by_id).with([@inventory1.id, @inventory2.id], {:include => :item}).and_return([@inventory1, @inventory2])
      
      @character.equipment.inventories
    end
    
    it 'should collect an array of inventories respective to number of their IDs' do
      @character.equipment.inventories.count(@inventory1).should == 2
      @character.equipment.inventories.count(@inventory2).should == 2
    end
    
    it 'should return empty array if character doesn\'t have equipped inventories' do
      @character.placements = {}
      
      @character.equipment.inventories.should == []
    end

    it 'should not re-collect inventories' do
      Inventory.should_receive(:find_all_by_id).once.and_return([@inventory1])
      
      @character.equipment.inventories
      @character.equipment.inventories
    end
  end
  
  
  describe '#inventories_by_placement' do
    before do
      @character = Factory(:character)
      @inventory1 = Factory(:inventory, :character => @character)
      @inventory2 = Factory(:inventory, :character => @character)

      
      @character.placements = {
        :additional => [@inventory1.id, @inventory2.id], 
        :left_hand  => [@inventory1.id],
        :right_hand => [@inventory2.id]
      }
    end

    it 'should return array of inventories by their IDs stored in defined placement' do
      @character.equipment.inventories_by_placement(:additional).should == [@inventory1, @inventory2]
      @character.equipment.inventories_by_placement(:left_hand).should == [@inventory1]
    end
    
    it 'should return empty array if there are no equipped items in the placement' do
      @character.equipment.inventories_by_placement(:empty_placement).should == []
    end
  end
  
  
  describe '#equip' do
    describe 'when placement have free space' do
      it 'should inventory ID to the placement'
      it 'recalculate equipped amount for inventory'
    end
    
    describe 'when placement does not have free space' do
      describe 'when placement is a main placement' do
        it 'should unequip previous inventory'
        it 'should equip passed inventory'
        it 'should return previous inventory'
        it 'should not try to re-equip inventory'
      end
    end
    
    it 'should return nil if inventory is not equippable'
    it 'should return nil if inventory cannot be put to this placement'
  end
  
  
  describe '#equip!' do
    before do
      @character = Factory(:character)
      @inventory = Factory(:inventory, :character => @character)
    end
    
    it 'should equip inventory' do
      @character.equipment.should_receive(:equip).with(@inventory, :left_hand).and_return(nil)
      
      @character.equipment.equip!(@inventory, :left_hand)
    end
    
    it 'should save previous inventory if equipping to non-free placement' do
      @other = mock_model(Inventory, :save => true)
      
      @character.equipment.stub!(:equip).and_return(@other)
      @other.should_receive(:save)
      
      @character.equipment.equip!(@inventory, :left_hand)
    end
    
    it 'should save inventory' do
      @character.equipment.equip!(@inventory, :left_hand)
      
      @inventory.should_not be_changed
    end
    
    it 'should save character' do
      @character.equipment.equip!(@inventory, :left_hand)
      
      @character.should_not be_changed
    end
    
    it 'should clear effect cache' do
      @character.equipment.should_receive(:clear_effect_cache!)
      
      @character.equipment.equip!(@inventory, :left_hand)
    end
    
    it 'should actually put inventory to the placement' do
      @character.equipment.inventories_by_placement(:left_hand).should be_empty
      
      @character.equipment.equip!(@inventory, :left_hand)
      
      @character.reload.equipment.inventories_by_placement(:left_hand).should include(@inventory)
    end
  end
  
  
  describe '#unequip' do
    before do
      @character = Factory(:character)
      @inventory = Factory(:inventory, :character => @character)
      
      @character.equipment.auto_equip!(@inventory)
    end
    
    it 'should remove item ID from passed placement' do
      @character.equipment.unequip(@inventory, :additional)
      
      @character.placements.values.flatten.count(@inventory.id).should == 4
    end
    
    it 'should reduce amount of equipped inventory' do
      lambda{
        @character.equipment.unequip(@inventory, :additional)
      }.should change(@inventory, :equipped).by(-1)
    end
    
    it 'should clear cached inventory list' do
      lambda{
        @character.equipment.unequip(@inventory, :additional)
      }.should change(@character.equipment, :inventories)
    end
  end
  
  
  describe '#unequip!' do
    before do
      @character = Factory(:character)
      @inventory = Factory(:inventory, :character => @character)
      
      @character.equipment.auto_equip!(@inventory)
    end

    it 'should unequip inventory' do
      @character.equipment.should_receive(:unequip).with(@inventory, :additional)
      
      @character.equipment.unequip!(@inventory, :additional)
    end
    
    it 'should save inventory' do
      @character.equipment.unequip!(@inventory, :additional)
      
      @inventory.should_not be_changed
    end
    
    it 'should save character' do
      @character.equipment.unequip!(@inventory, :additional)
      
      @character.should_not be_changed
    end
    
    it 'should clear inventory effect cache' do
      @character.equipment.should_receive(:clear_effect_cache!)
      
      @character.equipment.unequip!(@inventory, :additional)
    end
  end
end