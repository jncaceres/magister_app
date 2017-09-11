class TreeSerializer < ActiveModel::Serializer
  attributes :id, :text, :active, :score

  has_many :content_questions
  has_many :ct_questions
  has_many :feedbacks
end
