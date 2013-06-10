class Search
  include MusicFolder

  def initialize expression
    @sub_paths = `find #{ROOT_FOLDER} -iname "*#{expression}*"`.split("\n").sort
  end
private
  def sub_paths; @sub_paths; end
end