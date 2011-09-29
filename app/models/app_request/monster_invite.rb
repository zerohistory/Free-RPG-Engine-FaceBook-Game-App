class AppRequest::MonsterInvite < AppRequest::Base
  def monster
    @monster ||= Monster.find(data['monster_id']) if data && data['monster_id']
  end
  
  protected
  
  def after_accept
    super
    
    MonsterFight.create(:character => receiver, :monster => monster)
  end
end