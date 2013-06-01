require 'socket'
require './circular_distributed_queue'

class QueueServer
  def initialize(socket)
    @queue = CircularDistributedQueue.new
    @server = TCPServer.new(socket)
  end
  def start
    loop do
      Thread.start(@server.accept) do |s|
        message = s.recv(MAXLEN)
        message = message.split("\n")
        if message[0] != "start" && respond_to?(message[0])
          self.send(message[0], s, message)
        end
      end
    end
  end

  def next s, message
    if music = @queue.next
      s.send("OK\n#{music}", 0)
    else
      s.send("EMPTY", 0)
    end
  end

  def user_list s, message
    s.send("OK\n#{@queue.holder_list(message[1]).join("\n")}", 0)
  end

  def add s, message
    begin
      @queue.add message[1], message[2]
      s.send("OK",0)
    rescue
      s.send("ERROR",0)
    end
  end

  def delete s, message
    if @queue.delete message[1], message[2], message[3]
      s.send("OK", 0)
    else
      s.send("NOT_MODIFIED", 0)
    end
  end

  def current_music s, message
    if @queue.current_music
      s.send("OK\n#{@queue.current_music}", 0)
    else
      s.send("NONE", 0)
    end
  end

  def current_user s, message
    s.send("OK\n#{@queue.current_user}")
  end
end