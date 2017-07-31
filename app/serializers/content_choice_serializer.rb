class ContentChoiceSerializer < ActiveModel::Serializer
  attributes :id, :text, :right, :total

  def total
    3
  end
end
