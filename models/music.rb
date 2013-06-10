class Music < Path
  def self.audio? file
    mime = IO.popen(["mimetype", file], in: :close, err: :close).read.chomp
    mime = mime.split(": ")[-1]
    mime.split("/")[0] == "audio" || mime == "application/octet-stream"
  end
end