class Facebooker2Generator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :application_type, :type => :string, :default => 'regular'
  class_option :generate_code, :type => :boolean, :default => true, :desc => 'Automatically include required code into ApplicationController and routes.rb'

  def generate_facebooker2
    template  'facebooker.yml', 'config/facebooker.yml'
    copy_file 'initializer.rb', 'config/initializers/facebooker2.rb'

    if application_type == 'regular'
      required_code = "  include Facebooker2::Rails::Controller\n"
      if options.generate_code?
        inject_into_class 'app/controllers/application_controller.rb', ApplicationController do
          required_code
        end
      else
        puts <<-MSG
          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

          Add the following line to your app/controllers/application_controller.rb:

          #{required_code}
          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        MSG
      end
    else
      required_code = <<-CODE

  include Facebooker2::Rails::Controller

  before_filter :ensure_canvas_connected_to_facebook

  rescue_from Facebooker2::OAuthException do |exception|
    redirect_to 'http://www.facebook.com/'
  end

  private
  def ensure_canvas_connected_to_facebook
    ensure_canvas_connected(:email)
  end
      CODE

      routing_code = "\n  match '/facebook_oauth_connect' => 'application#facebook_oauth_connect'\n"

      if options.generate_code?
        inject_into_file 'app/controllers/application_controller.rb', :before => /^end$/ do
          required_code
        end

        inject_into_file 'config/routes.rb', routing_code, :after => /\.routes\.draw do$/
      else
        puts <<-MSG
          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

          Add the following lines to your app/controllers/application_controller.rb:
          #{required_code}
          Add the following line to your config/routes.rb:
          #{routing_code}
          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        MSG
      end
    end
  end
end
