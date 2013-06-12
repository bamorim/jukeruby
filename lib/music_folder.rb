require 'cgi'

module MusicFolder
  def directories
    @dirs ||= sub_paths.select{|p| File.directory?(p)}.collect do |d| 
      Path.new CGI.escape(d.sub(ROOT_FOLDER, "").sub(/^(\/)+/,""))
    end
  end

  def musics
    @musics ||= sub_paths.select do |o| 
      (not File.directory?(o)) && Music.audio?(o)
    end.collect do
      |m| Music.new CGI.escape(m.sub(ROOT_FOLDER, "").sub(/^(\/)+/,""))
    end
  end
end