class ReplySerializer < ActiveModel::Serializer
  attributes :id, :stage
  has_many :attempts
  has_one :user
end
