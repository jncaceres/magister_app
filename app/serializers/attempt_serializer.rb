class AttemptSerializer < ActiveModel::Serializer
  attributes :id
  has_many :picks
end
