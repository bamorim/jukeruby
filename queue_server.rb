require 'socket'
require './circular_distributed_queue'
SOCKET_FILE = ARGV[0]
MAXLEN = 1000

queue = CircularDistributedQueue.new
server = UNIXServer.new(SOCKET_FILE)
loop do
  Thread.start(server.accept) do |s|
    message = s.recv(MAXLEN)
    message = message.split("\n")
    if message[0] == "add"
      begin
        queue.add message[1], message[2]
        s.send("OK",0)
      rescue
        s.send("ERROR",0)
      end
    elsif message[0] == "next"
      if music = queue.next
        s.send("OK\n#{music}", 0)
      else
        s.send("EMPTY", 0)
      end
    end
  end
end