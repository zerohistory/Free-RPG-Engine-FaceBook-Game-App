require 'spec_helper'

describe FightingSystem::PlayerVsMonster::Simple do
  before do
    @system = FightingSystem::PlayerVsMonster::Simple
  end

  describe "when calculating damages for character and monster" do
    before do
      @character = mock('character',
        :attack_points => 1,
        :defence_points => 2
      )
      @monster = mock('monster',
        :attack => 3,
        :defence => 4,
        :minimum_damage => 5,
        :maximum_damage => 6,
        :minimum_response => 7,
        :maximum_response => 8
      )

      @system.stub!(:calculate_damage_for).and_return(9, 10)
    end

    it 'should calculate damage to monster' do
      @system.should_receive(:calculate_damage_for).with(1, 4, 5, 6).and_return(1)

      @system.calculate_damage(@character, @monster)
    end
    
    it 'should calculate damage to character' do
      @system.should_receive(:calculate_damage_for).with(3, 2, 7, 8).and_return(2)

      @system.calculate_damage(@character, @monster)
    end

    it 'should return damages as array' do
      @system.calculate_damage(@character, @monster).should == [9, 10]
    end
  end

  describe "when calculating damage for passed atributes" do
    describe 'when character is weaker than monster' do
      before do
        @attack = 1
        @defence = 100
        @minimum_damage = 50
        @maximum_damage = 100
      end

      describe 'when calculating damage to monster' do
        it 'should return minimum damage as lower possible damage' do
          @system.stub!(:rand).and_return(0)

          @system.calculate_damage_for(
            @attack, @defence, @minimum_damage, @maximum_damage
          ).should == 50
        end

        it 'should return minimum damage + 10% as higher possible damage' do
          @system.stub!(:rand).and_return(5499)

          @system.calculate_damage_for(
            @attack, @defence, @minimum_damage, @maximum_damage
          ).should == 55
        end
      end
    end

    describe 'when character is comparable to monster' do
      before do
        @attack = 100
        @defence = 100
        @minimum_damage = 50
        @maximum_damage = 100
      end

      describe 'when calculating damage to monster' do
        it 'should return average damage -10% as lower possible damage' do
          @system.stub!(:rand).and_return(0)

          @system.calculate_damage_for(
            @attack, @defence, @minimum_damage, @maximum_damage
          ).should == 70
        end

        it 'should return average damage +10% as higher possible damage' do
          @system.stub!(:rand).and_return(9_999)

          @system.calculate_damage_for(
            @attack, @defence, @minimum_damage, @maximum_damage
          ).should == 80
        end
      end
    end

    describe 'when character is higher than monster' do
      before do
        @attack = 100
        @defence = 1
        @minimum_damage = 50
        @maximum_damage = 100
      end

      describe 'when calculating damage to monster' do
        it 'should return maximum damage -10% as lower possible damage' do
          @system.stub!(:rand).and_return(0)

          @system.calculate_damage_for(
            @attack, @defence, @minimum_damage, @maximum_damage
          ).should == 95
        end

        it 'should return maximum as higher possible damage' do
          @system.stub!(:rand).and_return(1_000_000)

          @system.calculate_damage_for(
            @attack, @defence, @minimum_damage, @maximum_damage
          ).should == 100
        end
      end
    end
  end
end