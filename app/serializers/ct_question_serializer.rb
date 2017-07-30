class CtQuestionSerializer < ActiveModel::Serializer
  attributes :id, :type, :question
  has_many :ct_choices, key: :choices

  def ct_habilities
    object.ct_habilities.select(&:active)
  end
end
