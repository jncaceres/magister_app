class ContentChoiceSerializer < ActiveModel::Serializer
  attributes :id, :text, :right, :n

  def n
    object.picks.count(:reply_id)
  end
end
