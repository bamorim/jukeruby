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
      redis.rpush("user_#{user}", music)
    end

    def user_list user
      redis.lrange "user_#{user}", 0, -1
    end

    def current_music
      redis.get "current_music"
    end

    def remove user, music
      @redis.lrem "user_#{user}", 1, music
    end

  private
    def redis
      @redis ||= Redis.new
    end
  end
end