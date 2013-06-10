require 'sinatra'
require './jukeruby'
require 'json'
require 'haml'
require 'cgi'
require './models/music_folder'
require './models/path'
require './models/directory'
require './models/music'
require './models/search'
require './models/playlist'

ROOT_FOLDER = "/home/bamorim/Music/"

class JukeRuby::Application < Sinatra::Base
  set :bind, '0.0.0.0'

  set :session_secret, ENV["SESSION_KEY"] || "no_key"

  enable :sessions
end

require './routes/main.rb'
require './routes/api.rb'