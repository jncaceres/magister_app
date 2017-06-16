module VideosHelper
  def views_counter(video)
    $redis.get "video:#{video.id}"
  end
end
