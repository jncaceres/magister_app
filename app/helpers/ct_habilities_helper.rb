module CtHabilitiesHelper
  @@habilities = [["Interpretación",
  "To comprehend and express the meaning or significance of a wide\nvariety of experiences, situations, data, events, judgments, conventions, beliefs, rules,\nprocedures or criteria."],
 ["Análisis",
  "To identify the intended and actual inferential relationships among\nstatements, questions, concepts, descriptions or other forms of representation intended to\nexpress beliefs, judgments, experiences, reasons, information, or opinions."],
 ["Evaluación",
  "To assess the credibility of statements or other representations which are\naccounts or descriptions of a person's perception, experience, situation, judgment, belief,\nor opinion; and to assess the logical strength of the actual or intend inferential relationships\namong statements, descriptions, questions or other forms of representation."],
 ["Inferencia",
  "To identify and secure elements needed to draw reasonable conclusions;\nto form conjectures and hypotheses; to consider relevant information and to educe the\nconsequences flowing from data, statements, principles, evidence, judgments, beliefs,\nopinions, concepts, descriptions, questions, or other forms of representation."],
 ["Explicación",
  "To state the results of one's reasoning; to justify that reasoning in terms\nof the evidential, conceptual, methodological, criteriological and contextual considerations\nupon which one's results were based; and to present one's reasoning in the form of cogent\narguments."],
 ["Autoregulación",
  "Self-consciously to monitor one's cognitive activities, the elements\nused in those activities, and the results educed, particularly by applying skills in analysis and\nevaluation to one's own inferential judgments with a view toward questioning, confirming,\nvalidating, or correcting either one's reasoning or one's results."]]
 

  def build_habilities question
    if question.ct_habilities.empty? then
      @@habilities.map do |hab|
        question.ct_habilities.build name: hab.first, description: hab.last, active: false
      end
    end

    question
  end
end
