require 'socket'
require 'redis'
require 'open3'

ROOT_FOLDER = "/home/bamorim/Music/"

module JukeRuby
  class Player
    def play_next
      redis = Redis.new
      if redis.llen("users").to_i > 0
        user = redis.lpop("users")
        music = redis.lpop("user_#{user}")
        redis.set "current_music", music
        if redis.llen("user_#{user}").to_i > 0
          redis.rpush "users", user
        end
        play(music)
      else
        redis.del "current_music"
        sleep(1)
      end
    end

    def play file
      $stdout.puts "[player] Looking for #{file}"
      @pid = spawn("mplayer -quiet \"#{ROOT_FOLDER+file}\"", [:out, :err] => "/dev/null")
      Thread.current[:pid] = @pid
      $stdout.puts "[player] PLAYING #{file}"
      $stdout.puts "[player] PID #{@pid}"
      Process.wait
    end
  end
end