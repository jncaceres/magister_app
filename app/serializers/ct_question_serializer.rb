class CtQuestionSerializer < ActiveModel::Serializer
  attributes :id, :type, :question
  has_many :ct_choices, key: :choices
end
