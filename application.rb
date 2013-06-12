require 'bundler'
require 'json'
Bundler.require(:default)

Dir[File.expand_path("../lib/*.rb", __FILE__)].each{|f| require f}
Dir[File.expand_path("../models/*.rb", __FILE__)].each{|f| require f}

ROOT_FOLDER = "/home/bamorim/Music/"

module JukeRuby
  class Application < Sinatra::Base
    set :bind, '0.0.0.0'

    set :session_secret, ENV["SESSION_KEY"] || "no_key"

    enable :sessions

    def current_user
      session["user_key"] || params[:token]
    end
  end
end

Dir[File.expand_path("../routes/*.rb", __FILE__)].each{|f| require f}