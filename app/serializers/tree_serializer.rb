class TreeSerializer < ActiveModel::Serializer
  attributes :id, :text, :video, :iterations, :interpretation_sc, :analysis_sc, :evaluation_sc, :inference_sc, :explanation_sc, :selfregulation_sc, :content_sc, :questions

  has_one :content

  def questions
    %w(initial recuperative deeping).map do |q|
      {
        content: ContentQuestionSerializer.new(object.send(q + "_content_question")),
        ct:      CtQuestionSerializer.new(object.send(q + "_ct_question")),
        skills:  object.send(q + "_ct_question").ct_habilities.select(&:active).map(&:name)
      }
    end
  end
end
