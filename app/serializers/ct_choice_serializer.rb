class CtChoiceSerializer < ActiveModel::Serializer
  attributes :id, :text, :right, :n

  def n
    object.picks.count('distinct reply_id')
  end
end
