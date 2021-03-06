class Music < Path
  def tag
    @tag || TagLib::FileRef.open(full_path) do |fileref|
      tag = fileref.tag
      @tag = {title: tag.title, artist: tag.artist, album: tag.album, year: tag.year, track: tag.track} unless fileref.null?
    end
  end

  def image
    @cover ||= Cover.new full_path
  end
  # Performance Issue: Tag discovery takes too much time
  # TODO: LIBRARY!!! (But that would be a big change would probably make changes in API, let it to version 2)
  def with_tags
    nself = self.dup
    def nself.to_h
      if tag
        super.merge(tag)
      else
        super
      end
    end
    nself
  end

  def self.audio? file
    # Performance Issue: mimetype validation takes too much time.
    # TODO: Add a setting to enable that
    # TODO: Add a setting for filetypes
    return !!(file =~ /^*\.(mp3|m4a|wma|flac)$/)
    mime = IO.popen(["mimetype", file], in: :close, err: :close).read.chomp
    mime = mime.split(": ")[-1]
    mime.split("/")[0] == "audio" || mime == "application/octet-stream"
  end
end