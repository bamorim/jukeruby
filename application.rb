require 'sinatra'
require './jukeruby'
require 'json'
require 'haml'
require 'cgi'

Dir[File.expand_path("../lib/*.rb", __FILE__)].each{|f| require f}
Dir[File.expand_path("../models/*.rb", __FILE__)].each{|f| require f}

ROOT_FOLDER = "/home/bamorim/Music/"

class JukeRuby::Application < Sinatra::Base
  set :bind, '0.0.0.0'

  set :session_secret, ENV["SESSION_KEY"] || "no_key"

  enable :sessions
end

Dir[File.expand_path("../routes/*.rb", __FILE__)].each{|f| require f}