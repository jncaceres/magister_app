class TreeSerializer < ActiveModel::Serializer
  attributes :id, :text, :active, :score, :questions

  def questions
    %w(initial recuperative deeping).map do |tag|
      {
        content: ContentQuestionSerializer.new(object.send(tag + "_content_question")),
        ct:      CtQuestionSerializer.new(object.send(tag + "_ct_question")),
        skills:  object.send(tag + "_ct_question").ct_habilities.select(&:active).map(&:name)
      }
    end
  end

  has_many :feedbacks
end
