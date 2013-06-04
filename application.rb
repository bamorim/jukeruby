require 'sinatra'
require './jukeruby'
require 'json'
require 'haml'
require 'cgi'
require './web_helpers'

ROOT_FOLDER = "/home/bamorim/Music/"

class JukeRuby::Application < Sinatra::Base
  include JukeRuby::WebHelpers
  jukebox = JukeRuby::JukeboxClient.new
  set :bind, '0.0.0.0'

  enable :sessions

  before do
    session["user_key"] ||= random_string
  end

  get '/' do
    @current_music = jukebox.current_music
    haml :mobile
  end

  get "/user_key" do
    session["user_key"]
  end

  get '/musics/:path?' do
    @path = (CGI.unescape params[:path] if params[:path]) || ""
    @directories, @files = get_dir @path
    haml :directory
  end

  get '/search/?' do
    @directories, @files = search params[:q]
    haml :directory
  end

  get '/music/:path?' do
    unescaped_path = (CGI.unescape params[:path] if params[:path]) || ""
    @path = CGI.escape unescaped_path
    @filename = unescaped_path.split("/")[-1]
    haml :music
  end

  get '/add/:path' do
    relative_path = CGI.unescape params[:path]
    path = "#{ROOT_FOLDER}#{relative_path}"
    if is_audio(path) && jukebox.add(session["user_key"], path)
      {status: "ok"}.to_json
    else
      {status: "error", path: path}.to_json
    end
  end

  get "/my/?" do
    @musics = jukebox.user_list(session["user_key"]).collect{|x| x.split("/").last}
    haml :my
  end

  get "/now_playing.json" do
    if current_music = jukebox.current_music
      {status: "PLAYING", current_music: current_music.split("/")[-1]}.to_json
    else
      {status: "PAUSED"}.to_json
    end
  end
end
