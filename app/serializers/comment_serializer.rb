class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :video
  has_one :user
  has_one :parent
end
