class Directory < Path
  include MusicFolder
private

  def sub_paths
    @sub_paths ||= Dir["#{bracket_escaped_path}/*"].sort
  end
end