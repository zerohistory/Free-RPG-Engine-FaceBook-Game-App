# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','preinitializer'))
require 'spork'

Spork.prefork do
  require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
  require 'spec/autorun'
  require 'spec/rails'
  require "paperclip/matchers"
  
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}
end

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.

Spec::Runner.configure do |config|
  config.include Paperclip::Shoulda::Matchers
  config.include FacebookSpecHelper
  config.include SettingSpecHelper
  
  # == Mock Framework
  #
  # RSpec uses its own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner

  config.before :all do
    require File.expand_path(File.join(File.dirname(__FILE__),'..', "db", "seeds", "settings"))
  end
end

