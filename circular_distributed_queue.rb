class CircularDistributedQueue
  attr_reader :current_user, :current_music
  def initialize
    @user_queue = []
    @user_musics = {}
    @current_user = nil
    @current_music = nil
  end

  def add(holder, item)
    if !@user_musics[holder]
      @user_musics[holder] = [item]
      @user_queue << holder
    else
      @user_musics[holder] << item
    end
  end

  def holder_list(holder)
    @user_musics[holder] || []
  end

  def next
    if @current_user
      if @user_musics[@current_user] && @user_musics[@current_user].empty?
        @user_musics.delete @current_user
      else
        @user_queue << @current_user
      end
    end

    if !@user_queue.empty?
      @current_user = @user_queue.shift
      @current_music = @user_musics[@current_user].shift
    else
      @current_user = nil
      @current_music = nil
    end
  end
end