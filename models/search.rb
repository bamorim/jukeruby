class Search
  include MusicFolder

  def initialize expression
    @sub_paths = `find #{ROOT_FOLDER} -iname "*#{expression}*"`.split("\n").sort
  end

  def to_json(*a)
    to_h.to_json(*a)
  end

  def to_h
    {directories: directories, musics: musics}
  end
private
  def sub_paths; @sub_paths; end
end