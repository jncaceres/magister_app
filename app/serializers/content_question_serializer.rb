class ContentQuestionSerializer < ActiveModel::Serializer
  attributes :id, :type, :question
  has_many :content_choices, key: :choices
end
