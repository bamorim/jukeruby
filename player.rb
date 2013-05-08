require 'socket'

class Player
  def initialize(socket)
    @socket_path = socket
  end

  def play_next
    begin
      socket = UNIXSocket.open(@socket_path)
      socket.send("next", 0)
      message = socket.recv(MAXLEN).split("\n")
      if message[0] == "OK"
        play(message[1])
      else
        sleep(1)
      end
      socket.close
    rescue
      sleep(1) # Wait queue to finish
    end
  end

  def play file
    @pid = fork { puts "LOL #{exec "mpg123", "-q", file}" }
    Thread.current[:pid] = @pid
    $stdout.puts "[player] PLAYING #{file}"
    $stdout.puts "[player] PID #{@pid}"
    Process.wait
  end
end