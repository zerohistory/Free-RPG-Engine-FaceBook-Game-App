require 'spec_helper'

describe News::MonsterFight do
  it 'should delegate monster to monster fight' do
    @monster_fight = Factory(:monster_fight)
    @news = News::MonsterFight.create(:character => Factory(:character), :data => {:monster_fight_id => @monster_fight.id})
    
    @news.monster.should === @monster_fight.monster
  end
  
  describe '#monster_fight' do
    before do
      @monster_fight = Factory(:monster_fight)
      
      @news = News::MonsterFight.create(:character => Factory(:character), :data => {:monster_fight_id => @monster_fight.id})
    end
    
    it 'should return monster fight from data' do
      @news.monster_fight.should == @monster_fight
    end
  end
end