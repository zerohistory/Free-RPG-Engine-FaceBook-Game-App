class AppRequest::Invitation < AppRequest::Base
  protected
  
  def after_accept
    super

    receiver.friend_relations.establish!(sender)
    
    AppRequest::Invitation.between(sender, receiver).each do |invitation|
      invitation.ignore
    end
  end
end