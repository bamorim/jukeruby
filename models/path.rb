require 'cgi'

class Path
  def initialize dir
    @path = dir || "/"
  end

  def name
    full_path.split("/")[-1]
  end

  def path
    @path
  end

private
  
  def bracket_escaped_path
    full_path.gsub(/([\[\]\{\}\*\?\\])/, '\\\\\1')
  end

  def full_path
    "#{ROOT_FOLDER}#{CGI.unescape(@path)}"
  end
end