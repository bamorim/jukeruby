class JukeRuby::Application < Sinatra::Base
  get "/api/v1/now_playing" do
    if current_music = JukeRuby::JukeboxClient.new.current_music
      {status: "PLAYING", current_music: current_music.split("/")[-1]}.to_json
    else
      {status: "PAUSED"}.to_json
    end
  end

  # Get path info
  get '/api/v1/dir/:path?' do
  end

  # Get users playlist
  get '/api/v1/playlist' do
  end

  # Add a item identified by :path to the users playlist
  post '/api/v1/playlist' do
    pl = Playlist.new session["user_key"]
    if pl.add(params[:path])
      {status: "ok"}.to_json
    else
      {status: "error", path: path}.to_json
    end
  end

  # Removes an item identified by :path from the users playlist
  delete '/api/v1/playlist/:path' do

  end

  get '/api/v1/search/?' do
  end
end