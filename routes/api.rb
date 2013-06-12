class JukeRuby::Application < Sinatra::Base
  get "/api/v1/now_playing" do
    if current_music = Jukebox.new.current_music
      {status: "PLAYING", current_music: current_music.split("/")[-1]}.to_json
    else
      {status: "PAUSED"}.to_json
    end
  end

  # Get path info
  get '/api/v1/dir/:path?' do
    Directory.new(params[:path]).to_json
  end

  # Get music info
  get '/api/v1/music/:path' do
    Music.new(params[:path]).with_tags.to_json
  end

  # Get music info
  get '/api/v1/music/:path/image' do
    image = Music.new(params[:path]).image
    if image
      content_type image.mime
      body image.content
    else
      status 404
    end
  end

  # Get users playlist
  get '/api/v1/playlist' do
    Playlist.new(session["user_key"]).musics.to_json
  end

  # Add a item identified by :path to the users playlist
  post '/api/v1/playlist' do
    pl = Playlist.new current_user
    if pl.add(params[:path])
      status 204
    else
      status 500
      {path: path}.to_json
    end
  end

  # Removes an item identified by :path from the users playlist
  delete '/api/v1/playlist/:path' do
    pl = Playlist.new current_user
    if pl.remove params[:path]
      status 204
    else
      status 404
    end
  end

  get '/api/v1/search/?' do
    Search.new(params[:q]).to_json
  end
end