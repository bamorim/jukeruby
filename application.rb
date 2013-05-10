require 'sinatra'
require './jukeruby'
require 'json'
require 'haml'

ROOT_FOLDER = "/home/bamorim/Music/"

jukebox = JukeRuby::JukeboxClient.new
set :bind, '0.0.0.0'

def escape_brackets(s)
  s.gsub(/[\\\{\}\[\]\*\?]/) { |x| "\\"+x }
end

def file_list_hash fl
  x = fl.collect{|x| x.sub(ROOT_FOLDER, "")}
  x.collect{|x| {name: x.split("/")[-1], path: x.gsub("[", "%5B").gsub("]","%5D")}}
end

def is_audio file
  mime = IO.popen(["file","--mime", "-b", file], in: :close, err: :close).read.chomp
  mime = mime.split(";")[0]
  mime.split("/")[0] == "audio" || mime == "application/octet-stream"
end

def get_dir dir
  path = "#{ROOT_FOLDER}#{escape_brackets(dir)}"
  sub_paths = Dir["#{path}/*"]
  directories = file_list_hash sub_paths.select{|o| File.directory?(o)}
  files = file_list_hash sub_paths.select{|o| (not File.directory?(o)) && is_audio(o)}
  [directories, files]
end

def random_string
  o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
  (0...50).map{ o[rand(o.length)] }.join
end

enable :sessions

before do
  session["user_key"] ||= random_string
end

get '/' do
  @current_music = jukebox.current_music
  haml :mobile
end

get '/musics/*' do
  @path = params[:splat].join("/")
  @directories, @files = get_dir @path
  haml :directory
end

get '/music/*' do
  @path = params[:splat].join("/")
  @filename = @path.split("/")[-1]
  @path = @path.gsub("[", "%5B").gsub("]","%5D")
  haml :music
end

get '/add/*' do
  path = "#{ROOT_FOLDER}#{params[:splat].join("/")}"
  if is_audio(path) && jukebox.add(session["user_key"], path)
    redirect "/"
  else
    redirect back
  end
end

get "/my/?" do
  @musics = jukebox.user_list(session["user_key"]).collect{|x| x.split("/").last}
  haml :my
end