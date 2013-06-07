require 'socket'

APP_PORT = 9292

s = UDPSocket.new
s.bind("0.0.0.0",5853)
server_info = "com.pytera.jukebox.appaddr,#{APP_PORT}"
loop do
  body, sender = s.recvfrom(1024)
  p "#{sender[3]} sent: #{body}"
  data = body.split(",")
  if data[0] == "com.pytera.jukebox.discovery" && (Integer(data[1]) rescue false)
    p "[DiscoveryServer] Sending \"#{server_info}\" to #{sender[3]} at #{data[1]}"
    s.send server_info, 0, sender[3], Integer(data[1])
  end
end