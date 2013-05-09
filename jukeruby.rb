MAXLEN = 1000
SOCKET_FILE = 'queue.sock'
require 'socket'
require './queue_server'
require './player'

module JukeRuby
  class JukeboxServer
    attr_reader :player
    def initialize
      @queue_pid = fork do
        server = QueueServer.new SOCKET_FILE
        server.start
      end

      player = Player.new SOCKET_FILE
      loop { player.play_next }

      ObjectSpace.define_finalizer(self, proc {
        Process.kill 9, @queue_pid
        Process.kill 9, @player_thread[:pid]
        File.delete(SOCKET_FILE)
      })
    end
  end

  class JukeboxClient
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

    def user_list user
      queue_socket = UNIXSocket.new(SOCKET_FILE)
      queue_socket.send(["user_list", user].join("\n"), 0)
      response = queue_socket.recv(MAXLEN).split("\n")
      if response[0] == "OK"
        response[1..-1]
      else
        response[0]
      end
    end
  end
end