class ContentChoiceSerializer < ActiveModel::Serializer
  attributes :id, :text, :right, :total

  def total
    object.picks.count
  end
end
