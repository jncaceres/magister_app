class ContentChoiceSerializer < ActiveModel::Serializer
  attributes :id, :text, :right, :total

  def total
    7
  end
end
