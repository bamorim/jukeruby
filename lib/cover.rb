class Cover
  attr_accessor :content
  attr_accessor :mime
  def initialize(full_path,width=200,height=200)
    # Try to get picture and mime from tag
    pic, @mime = get_tag_pic full_path
    # If not found, get it from directory
    pic, @mime = get_dir_pic full_path.split("/")[0..-2].join("/") unless pic
    @content = pic.resize_to_fill(width,height).to_blob
  end

  private
  def get_pic pics
    pic = Magick::ImageList.new
    tag = pics.inject{|m,n| m.picture.length > n.picture.length ? n : m }
    [pic.from_blob(tag.picture), tag.mime_type] if tag
  end

  # TODO: Find other file formats if jpeg not found
  # TODO: Add a setting to disable this
  def get_dir_pic dir_path
    img_path = `find "#{dir_path}" -iname "*.jpg"`.split("\n").first
    [Magick::ImageList.new(img_path), "image/jpeg"]
  end

  def get_tag_pic full_path
    extension = full_path.split(".").last
    if extension == "mp3"
      TagLib::MPEG::File.open(full_path) { |file| get_pic file.id3v2_tag.frame_list('APIC') }
    elsif extension == "flac"
      TagLib::FLAC::File.open(full_path) { |file| get_pic file.picture_list }
    end
  end
end