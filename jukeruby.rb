MAXLEN = 1000
SOCKET_FILE = 'queue.sock'
require 'socket'
require './queue_server'
require './player'

class JukeRuby
  attr_reader :player
  def initialize
    @queue_pid = fork do
      server = QueueServer.new SOCKET_FILE
      server.start
    end

    @player_thread = Thread.new do
      player = Player.new SOCKET_FILE
      loop { player.play_next }
    end

    ObjectSpace.define_finalizer(self, proc {
      Process.kill 9, @queue_pid
      Process.kill 9, @player_thread[:pid]
      File.delete(SOCKET_FILE)
    })
  end

  def add user, music
    queue_socket = UNIXSocket.new(SOCKET_FILE)
    queue_socket.send(["add", user, music].join("\n"), 0)
    response = queue_socket.recv(MAXLEN).split("\n")
    if response[0] == "OK"
      true
    else
      false
    end
  end
end