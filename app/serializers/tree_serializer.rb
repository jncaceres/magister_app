class TreeSerializer < ActiveModel::Serializer
  attributes :id, :text, :active, :video, :iterations, :interpretation_sc, :analysis_sc, :evaluation_sc, :inference_sc, :explanation_sc, :selfregulation_sc, :content_sc

  has_many :content_questions
  has_many :ct_questions
  has_many :feedbacks

  # def total
  #   object.user_tree_performances.count
  # end

  # def questions
  #   clean = -> (q) {
  #     case q
  #       when "initial" then "Inicial"
  #       when "recuperative" then "Recuperativa"
  #       when "deeping" then "Profundización"
  #       else "Desconocido"
  #     end
  #   }

  #   %w(initial recuperative deeping).map do |q|
  #     {
  #       type:    clean.call(q),
  #       content: ContentQuestionSerializer.new(object.send(q + "_content_question")),
  #       ct:      CtQuestionSerializer.new(object.send(q + "_ct_question")),
  #       skills:  object.send(q + "_ct_question").ct_habilities.select(&:active).map(&:name)
  #     }
  #   end
  # end
end
