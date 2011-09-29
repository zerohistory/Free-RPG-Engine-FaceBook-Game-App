module Jobs
  class UserDataUpdate < Struct.new(:user_ids)
    def perform
      user_ids.each do |id|
        user = User.find_by_id(id)
        
        user.update_social_data!
      end
    end
  end
end