MAXLEN = 1000
SOCKET_FILE = 5678
require 'socket'
require './queue_server'

module JukeRuby
  class JukeboxClient
    def add user, music
      response = queue_send "add", user, music
      response[0] == "OK"
    end

    def user_list user
      response = queue_send "user_list", user
      if response[0] == "OK"
        response[1..-1]
      else
        response[0]
      end
    end

    def current_music
      response = queue_send "current_music"
      response[1].force_encoding('UTF-8') if response[0] == "OK"
    end

  private
    def queue_send *messages
      queue_socket = TCPSocket.new("localhost", SOCKET_FILE)
      queue_socket.send(messages.join("\n"), 0)
      queue_socket.recv(MAXLEN).split("\n")
    end

  end
end