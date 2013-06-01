require 'sinatra'
require './jukeruby'
require 'json'
require 'haml'
require 'cgi'

ROOT_FOLDER = "/home/bamorim/Music/"

jukebox = JukeRuby::JukeboxClient.new
set :bind, '0.0.0.0'

def escape_brackets(s)
  s.gsub(/[\\\{\}\[\]\*\?]/) { |x| "\\"+x }
end

def escape_url(url)
  url.split("/").map do |k| 
    URI.escape(k.split(" ").map{ CGI.escape(k) }.join(" "))
  end.join("/")
end

def file_list_hash fl
  x = fl.collect{|x| x.sub(ROOT_FOLDER, "")}
  x.collect{|x| {name: x.split("/")[-1], path: CGI.escape(x)}}
end

def is_audio file
  # mime = IO.popen(["file","--mime", "-b", file], in: :close, err: :close).read.chomp
  # mime = mime.split(";")[0]
  # mime.split("/")[0] == "audio" || mime == "application/octet-stream"
  mime = IO.popen(["mimetype", file], in: :close, err: :close).read.chomp
  mime = mime.split(": ")[-1]
  mime.split("/")[0] == "audio" || mime == "application/octet-stream"
end

def get_dir dir
  path = "#{ROOT_FOLDER}#{escape_brackets(dir)}"
  sub_paths = Dir["#{path}/*"]
  get_file_list sub_paths
end

def search expression
  paths = `find #{ROOT_FOLDER} -iname "*#{expression}*"`.split("\n")
  get_file_list paths
end

def get_file_list paths
  directories = file_list_hash paths.select{|o| File.directory?(o)}
  files = file_list_hash paths.select{|o| (not File.directory?(o)) && is_audio(o)}
  directories.sort_by! { |k| k[:name] }
  files.sort_by! { |k| k[:name] }
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
