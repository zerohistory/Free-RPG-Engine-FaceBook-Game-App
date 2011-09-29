module Jobs
  class RequestDelete < Struct.new(:request_ids)
    def perform
      AppRequest::Base.find_all_by_id(request_ids).each do |request|
        request.delete_from_facebook!
      end
    end
  end
end