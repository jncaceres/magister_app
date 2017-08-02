class ReplySerializer < ActiveModel::Serializer
  attributes :id, :stage
  has_one :user
  has_one :tree
end
