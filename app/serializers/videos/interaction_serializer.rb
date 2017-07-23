class Videos::InteractionSerializer < ActiveModel::Serializer
  attributes :id, :video_id, :user_id, :action, :timestamp

  def timestamp
    Time.at(object.seconds)
      .utc
      .strftime "%H:%M:%S"
  end
end
