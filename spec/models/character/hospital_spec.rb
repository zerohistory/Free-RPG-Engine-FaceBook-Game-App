require 'spec_helper'

describe Character do
  describe 'when getting hospital healing price' do
    before do
      @character = Factory(:character)
    end
    
    it 'should use base price' do
      @character.hospital_price.should == 10
    end
    
    it 'should add price per point per level' do
      @character.hp -= 10
      
      @character.hospital_price.should == 35 # 10 + 2.5 * 10 points * level 1
      
      @character.level = 5
      
      @character.hospital_price.should == 135 # 10 + 2.5 * 10 points * level 5
    end
  end
  
  describe 'when getting time to next hospital usage' do
    before do
      @character = Factory(:character)
    end
    
    it 'should return time in seconds to next possible usage basing on hospital delay' do
      @character.should_receive(:hospital_delay).and_return 10.minutes
      
      Timecop.freeze(Time.now) do
        @character.hospital_used_at = 5.minutes.ago
      
        @character.time_to_next_hospital.should == 5.minutes
      end
    end
    
    it 'should return zero if hospital delay time has already passed' do
      @character.time_to_next_hospital.should == 0
    end
    
    it 'should return integer value' do
      @character.should_receive(:hospital_delay).and_return 10.minutes
      @character.hospital_used_at = 5.minutes.ago
      
      @character.time_to_next_hospital.should be_kind_of(Integer)
    end
    
  end
end