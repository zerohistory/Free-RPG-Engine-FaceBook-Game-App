module FacebookSpecHelper
  def fake_fb_user
    mock("facebook user", 
      :id => 123456789,
      :client => mock("mogli client", 
        :access_token => "fake token",
        :expiration   => 1.day.from_now
      )
    )
  end
end