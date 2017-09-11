class ReportSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :course
  has_many :trees
end
