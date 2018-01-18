class CtQuestionSerializer < ActiveModel::Serializer
  attributes :id, :type, :question
  has_many :choices
end
