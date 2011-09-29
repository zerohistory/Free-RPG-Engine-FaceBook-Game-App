set :application, "tribalpride"

set :repository,  "git@git.railorz.com:facebook/blondet.git"
set :branch,  "master"

server "blondet.railorz.com", :web, :app, :db, :primary => true

set :user, "game_staging"

set :deploy_to, "/home/#{user}/#{application}"

set :rails_env, "staging"

default_environment["RAILS_ENV"] = "staging"

set :facebooker_config, {
  :app_id           => "108096015917910",
  :api_key          => "41a1a7c59d275c588aab7f9f50d30481",
  :secret           => "1baea35ed35d7dfa0db2a8cb02f5d585",
  :canvas_page_name => "tribalpride-dev",
  :callback_url     => "http://blondetdev.railorz.com",

  :set_asset_host_to_callback_url => true
}

set :database_config, {
  :adapter  => "mysql",
  :host     => "localhost",
  :database => "game_staging",
  :username => "game",
  :password => "K5jIU87vc2kSFw=="
}
