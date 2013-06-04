MAXLEN = 1000
SOCKET_FILE = 5678
require 'socket'
require './player'

puts "[JukeBox Server] Running..."

player = JukeRuby::Player.new
loop { player.play_next }
