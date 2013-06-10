class JukeRuby::Application < Sinatra::Base
  before do
    session["user_key"] ||= random_string
  end

  get '/' do
    @current_music = @@jukebox.current_music
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

  get '/remove/:path' do
    relative_path = CGI.unescape params[:path]
    path = "#{ROOT_FOLDER}#{relative_path}"
    @@jukebox.remove session['user_key'], path
    redirect "/"
  end

  get "/my/?" do
    @musics = @@jukebox.user_list(session["user_key"])
    haml :my
  end
end