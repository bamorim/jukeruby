class Playlist
  def initialize id
    @id = id
    @client = JukeRuby::JukeboxClient.new
  end

  def add music
    path = CGI.unescape music
    @client.add(@id, path) > 0 if Music.audio?(path)
  end

  def remove music
    @client.remove(@id, CGI.unescape(music)) > 0
  end

  def musics
    @client.user_list(@id).collect do |x| 
      Music.new CGI.escape(x)
    end
  end
end