class ContentQuestionSerializer < ActiveModel::Serializer
  attributes :id, :type, :question, :total
  has_many :content_choices, key: :choices
end
