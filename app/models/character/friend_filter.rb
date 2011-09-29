class Character
  class FriendFilter
    def initialize(character)
      @character = character
    end
    
    def all
      @all ||= @character.user.friend_ids
    end
    
    def in_relation
      @in_relation ||= @character.friend_relations.facebook_ids
    end

    def app_users
      @app_users ||= all.empty? ? [] : app_users_from(all)
    end
    
    def non_app_users
      @non_app_users ||= all.empty? ? [] : non_app_users_from(all)
    end
    
    def invited_recently
      @invited_recently ||= AppRequest::Invitation.from(@character).receiver_ids
    end
    
    def for_invitation(limit = 10)
      ids = all - invited_recently - in_relation
      ids.shuffle!
      ids[0, limit]
    end
        
    protected
    
    def app_users_from(list)
      User.connection.select_values(
        'SELECT facebook_id FROM users WHERE facebook_id IN (%s)' % list.join(',')
      ).collect{|f| f.to_i }
    end
    
    def non_app_users_from(list)
      list - app_users_from(list)
    end
  end
end