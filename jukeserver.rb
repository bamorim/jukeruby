MAXLEN = 1000
SOCKET_FILE = 'queue.sock'
require 'socket'
require './queue_server'
require './player'

@queue_pid = fork do
  server = QueueServer.new SOCKET_FILE
  server.start
end

puts "[JukeBox Server] Running..."

player = JukeRuby::Player.new SOCKET_FILE
loop { player.play_next }