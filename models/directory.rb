class Directory < Path
  include MusicFolder

  def to_h
    super.merge({directories: directories, musics: musics})
  end
private

  def sub_paths
    @sub_paths ||= Dir["#{bracket_escaped_path}/*"].sort
  end
end