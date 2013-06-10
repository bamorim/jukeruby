class JukeRuby::Application < Sinatra::Base
  def random_string
    o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    (0...50).map{ o[rand(o.length)] }.join
  end

  before do
    session["user_key"] ||= random_string
  end

  get '/' do
    @current_music = JukeRuby::JukeboxClient.new.current_music
    haml :mobile
  end

  get '/musics/:path?' do
    @dir = Directory.new params[:path]
    haml :directory
  end

  get '/search/?' do
    @dir = Search.new params[:q]
    haml :directory
  end

  get '/music/:path?' do
    @music = Music.new params[:path]
    haml :music
  end

  get '/remove/:path' do
    Playlist.new(session['user_key']).remove params[:path]
    redirect "/"
  end

  get "/my/?" do
    @musics = Playlist.new(session["user_key"]).musics
    haml :my
  end
end