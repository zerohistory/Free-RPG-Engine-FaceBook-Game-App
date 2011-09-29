Facebooker2.load_facebooker_yaml

ActionController::Base.asset_host = Proc.new{|source|
  Facebooker2.callback_url unless ENV['OFFLINE']
}