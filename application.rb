require 'sinatra'
require './jukeruby'
require 'json'
require 'haml'
require 'cgi'
require './web_helpers'

ROOT_FOLDER = "/home/bamorim/Music/"

class JukeRuby::Application < Sinatra::Base
  include JukeRuby::WebHelpers
  @@jukebox = JukeRuby::JukeboxClient.new
  set :bind, '0.0.0.0'

  set :session_secret, ENV["SESSION_KEY"] || "no_key"

  enable :sessions

  get "/now_playing.json" do
    if current_music = jukebox.current_music
      {status: "PLAYING", current_music: current_music.split("/")[-1]}.to_json
    else
      {status: "PAUSED"}.to_json
    end
  end
end

require './routes/main.rb'
require './routes/api.rb'