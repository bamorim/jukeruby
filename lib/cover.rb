class Cover
  attr_accessor :content
  attr_accessor :mime
  def initialize(content,mime,width=200,height=200)
    pic = Magick::ImageList.new
    pic.from_blob(content)
    @content = pic.resize_to_fill(width,height).to_blob
    @mime = mime
  end
end