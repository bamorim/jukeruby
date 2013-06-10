class JukeRuby::Application < Sinatra::Base
  get "/api/v1/now_playing" do
    if current_music = @@jukebox.current_music
      {status: "PLAYING", current_music: current_music.split("/")[-1]}.to_json
    else
      {status: "PAUSED"}.to_json
    end
  end

  # Get path info
  get '/api/v1/dir/:path?' do
    @path = (CGI.unescape params[:path] if params[:path]) || ""
    @directories, @files = get_dir @path
    {directories: @directories, files: @files}.to_json
  end

  # Get users playlist
  get '/api/v1/playlist' do
    @@jukebox.user_list(session["user_key"]).to_json
  end

  # Add a item identified by :path to the users playlist
  post '/api/v1/playlist' do
    relative_path = CGI.unescape params[:path]
    path = "#{ROOT_FOLDER}#{relative_path}"
    if is_audio(path) && @@jukebox.add(session["user_key"], path)
      {status: "ok"}.to_json
    else
      {status: "error", path: path}.to_json
    end
  end

  # Removes an item identified by :path from the users playlist
  delete '/api/v1/playlist/:path' do
    relative_path = CGI.unescape params[:path]
    path = "#{ROOT_FOLDER}#{relative_path}"
    @@jukebox.remove session['user_key'], path
  end

  get '/api/v1/search/?' do
    @directories, @files = search params[:q]
    {directories: directories, files: @files}
  end
end