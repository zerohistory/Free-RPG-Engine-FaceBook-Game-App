module Jobs
  class UserRequestCheck < Struct.new(:user_id)
    def perform
      AppRequest::Base.check_user_requests(User.find(user_id))
    end
  end
end