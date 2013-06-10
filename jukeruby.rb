MAXLEN = 1000
SOCKET_FILE = 5678
require 'socket'
require 'redis'

module JukeRuby
  class JukeboxClient
    def add user, music
      if !redis.lrange("users", 0, -1).include? user
        redis.lpush "users", user
      end
      msg = redis.rpush("user_#{user}", music)
      msg > 0
    end

    def user_list user
      list = redis.lrange "user_#{user}", 0, -1
      list.collect do |x| 
        {name: x.split("/").last, path: CGI.escape(x.sub(ROOT_FOLDER, ""))}
      end
    end

    def current_music
      redis.get "current_music"
    end

    def remove user, music
      musics = @redis.lrem "user_#{user}", 1, music
    end

  private
    def redis
      @redis ||= Redis.new
    end
  end
end