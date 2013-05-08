require 'socket'
require './circular_distributed_queue'
MAXLEN = 1000

require 'socket'
class JukeRuby
  def initialize
    @queue_server, @queue_client = Socket.pair(:UNIX, :DGRAM, 0)

    @queue_pid = fork do
      queue = CircularDistributedQueue.new
      while true
        message = @queue_client.recv(MAXLEN).split("\n")
        if message[0] == "add"
          begin
            queue.add message[1], message[2]
            @queue_client.send("OK",0)
          rescue
            @queue_client.send("ERROR",0)
          end
        elsif message[0] == "next"
          if music = queue.next
            @queue_client.send("OK\n#{music}", 0)
          else
            @queue_client.send("EMPTY", 0)
          end
        end
      end
    end

    @player_pid = fork do
      while true
        @queue_server.send("next", 0)
        message = @queue_server.recv(MAXLEN).split("\n")
        if message[0] == "OK"
          $stdout.puts "PLAYING #{message[1]}"
          pid = fork { exec "mpg123", "-q", message[1]}
          Process.wait
        else
          # $stdout.puts "NO MUSIC"
          sleep(1)
        end
      end
    end
  end

  def add user, music
    @queue_server.send(["add", user, music].join("\n"), 0)
    response = @queue_server.recv(MAXLEN).split("\n")
    if response[0] == "OK"
      true
    else
      false
    end
  end
end