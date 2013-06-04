module JukeRuby
  module WebHelpers
    def escape_brackets(s)
      s.gsub(/[\\\{\}\[\]\*\?]/) { |x| "\\"+x }
    end

    def escape_url(url)
      url.split("/").map do |k| 
        URI.escape(k.split(" ").map{ CGI.escape(k) }.join(" "))
      end.join("/")
    end

    def file_list_hash fl
      x = fl.collect{|x| x.sub(ROOT_FOLDER, "")}
      x.collect{|x| {name: x.split("/")[-1], path: CGI.escape(x)}}
    end

    def is_audio file
      # mime = IO.popen(["file","--mime", "-b", file], in: :close, err: :close).read.chomp
      # mime = mime.split(";")[0]
      # mime.split("/")[0] == "audio" || mime == "application/octet-stream"
      mime = IO.popen(["mimetype", file], in: :close, err: :close).read.chomp
      mime = mime.split(": ")[-1]
      mime.split("/")[0] == "audio" || mime == "application/octet-stream"
    end

    def get_dir dir
      path = "#{ROOT_FOLDER}#{escape_brackets(dir)}"
      sub_paths = Dir["#{path}/*"]
      get_file_list sub_paths
    end

    def search expression
      paths = `find #{ROOT_FOLDER} -iname "*#{expression}*"`.split("\n")
      get_file_list paths
    end

    def get_file_list paths
      directories = file_list_hash paths.select{|o| File.directory?(o)}
      files = file_list_hash paths.select{|o| (not File.directory?(o)) && is_audio(o)}
      directories.sort_by! { |k| k[:name] }
      files.sort_by! { |k| k[:name] }
      [directories, files]
    end

    def random_string
      o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
      (0...50).map{ o[rand(o.length)] }.join
    end
  end
end