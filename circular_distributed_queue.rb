class CircularDistributedQueue
  def initialize
    @user_queue = []
    @user_musics = {}
  end

  def add(holder, item)
    if !@user_musics[holder]
      @user_musics[holder] = [item]
      @user_queue << holder
    else
      @user_musics[holder] << item
    end
  end

  def next
    if !@user_queue.empty?
      next_user = @user_queue.shift
      next_music = @user_musics[next_user].shift
      if @user_musics[next_user].empty?
        @user_musics.delete next_user
      else
        @user_queue << next_user
      end
      next_music
    end
  end
end