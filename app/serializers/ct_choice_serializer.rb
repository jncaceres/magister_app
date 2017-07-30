class CtChoiceSerializer < ActiveModel::Serializer
  attributes :id, :text, :right, :total

  def total
    5
  end
end
