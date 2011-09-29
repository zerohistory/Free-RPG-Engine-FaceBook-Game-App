set :application, "tribalpride"

set :repository,  "git@git.railorz.com:facebook/blondet.git"
set :branch,  "production"

server "blondet.railorz.com", :web, :app, :db, :primary => true

set :user, "game"

set :deploy_to, "/home/#{user}/#{application}"

set :rails_env, "production"

default_environment["RAILS_ENV"] = "production"

set :facebooker_config, {
  :app_id           => "107717989269253",
  :api_key          => "b7d225734f5b329626a58d4944c5b2eb",
  :secret           => "8bf77b8bcfb30abd80560ccda4d299a7",
  :canvas_page_name => "tribalpride",
  :callback_url     => "http://blondet.railorz.com",

  :set_asset_host_to_callback_url => true
}

set :database_config, {
  :adapter  => "mysql",
  :host     => "localhost",
  :database => "game_production",
  :username => "game",
  :password => "K5jIU87vc2kSFw=="
}
