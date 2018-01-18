class PickSerializer < ActiveModel::Serializer
  attributes :id
  has_one :selectable
end
