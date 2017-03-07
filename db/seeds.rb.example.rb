# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#User.destroy_all
#Course.destroy_all
#Content.destroy_all

User.create(first_name: 'Harold', last_name: 'Muller', email: 'hlmuller@uc.cl', role: 2, password: '123456', asistencia: false)
User.create(first_name: 'Pablo', last_name: 'Espinosa', email: 'pespinosa@uc.cl', role: 2, password: '123456', asistencia: false)
User.create(first_name: 'Vicente', last_name: 'Martin', email: 'vrmartin@uc.cl', role: 2, password: '123456', asistencia: false)



#interpretation = CtHability.create(name: 'Interpretación', description: "To comprehend and express the meaning or significance of a wide
#variety of experiences, situations, data, events, judgments, conventions, beliefs, rules,
#procedures or criteria.")

interpretation = CtHability.create(name: 'Interpretación', description: "To comprehend and express the meaning or significance of a wide
variety of experiences, situations, data, events, judgments, conventions, beliefs, rules,
procedures or criteria.")

analysis = CtHability.create(name: 'Análisis', description: "To identify the intended and actual inferential relationships among
statements, questions, concepts, descriptions or other forms of representation intended to
express beliefs, judgments, experiences, reasons, information, or opinions.")

evaluation = CtHability.create(name: 'Evaluación', description: "To assess the credibility of statements or other representations which are
accounts or descriptions of a person's perception, experience, situation, judgment, belief,
or opinion; and to assess the logical strength of the actual or intend inferential relationships
among statements, descriptions, questions or other forms of representation.")

inference = CtHability.create(name: 'Inferencia', description: "To identify and secure elements needed to draw reasonable conclusions;
to form conjectures and hypotheses; to consider relevant information and to educe the
consequences flowing from data, statements, principles, evidence, judgments, beliefs,
opinions, concepts, descriptions, questions, or other forms of representation.")

explanation = CtHability.create(name: 'Explicación', description: "To state the results of one's reasoning; to justify that reasoning in terms
of the evidential, conceptual, methodological, criteriological and contextual considerations
upon which one's results were based; and to present one's reasoning in the form of cogent
arguments.")

selfregulation = CtHability.create(name: 'Autoregulación', description: "Self-consciously to monitor one's cognitive activities, the elements
used in those activities, and the results educed, particularly by applying skills in analysis and
evaluation to one's own inferential judgments with a view toward questioning, confirming,
validating, or correcting either one's reasoning or one's results.")



interpretation.ct_subhabilities.create(name: 'Categorización', description: "-To apprehend or appropriately formulate categories, distinctions, or frameworks
for understanding, describing or characterizing information.\n
-To describe experiences, situations, beliefs, events, etc. so that they take on
comprehensible meanings in terms of appropriate categorizations, distinctions, or
frameworks.")

interpretation.ct_subhabilities.create(name: "Decodificar significado", description: "To detect, attend to, and describe the informational content, affective purport,
directive functions, intentions, motives, purposes, social significance, values, views, rules,
procedures, criteria, or inferential relationships expressed in convention-based
communication systems, such as in language, social behaviors, drawings, numbers, graphs,
tables, charts, signs and symbols.")


interpretation.ct_subhabilities.create(name: 'Clarificar significados', description: "-To paraphrase or make explicit, through stipulation, description, analogy or
figurative expression, the contextual, conventional or intended meanings of words, ideas,
concepts, statements, behaviors, drawings, numbers, signs, charts, graphs, symbols, rules,
events or ceremonies.\n
-To use stipulation, description, analogy or figurative expression to remove
confusing, unintended vagueness or ambiguity, or to design a reasonable procedure for so
doing.")


analysis.ct_subhabilities.create(name: 'Examinar ideas', description: "-To determine the role various expressions play or are intended to play in the
context of argument, reasoning or persuasion.\n
-To define terms.\n
-To compare or contrast ideas, concepts, or statements.\n
-To identify issues or problems and determine their component parts, and also to
identify the conceptual relationships of those parts to each other and to the whole.")


analysis.ct_subhabilities.create(name: 'Detectar argumentos', description: "Given a set of statements, descriptions, questions or graphic representations, to
determine whether or not the set expresses, or is intended to express, a reason or reasons
in support of or contesting some claim, opinion or point of view.")

analysis.ct_subhabilities.create(name: 'Analizar argumentos', description: "-Given the expression of a reason or reasons intended to support or contest some
claim, opinion or point of view, to identify and differentiate:\n
(a) the intended main conclusion\n
(b) the premises and reasons advanced in support of the main conclusion\n
(c) further premises and reasons advanced as backup or support for those premises and reasons intended as supporting the main conclusion\n
(d) additional unexpressed elements of that reasoning, such as intermediary conclusions, unstated assumptions or
presuppositions\n
(e) the overall structure of the argument or intended chain of reasoning\n
(f) any items contained in the body of expressions being examined which are not intended to be taken as part of the reasoning being expressed or its intended background.")



evaluation.ct_subhabilities.create(name: 'Evaluar demandas', description: "-To recognize the factors relevant to assessing the degree of credibility to ascribe
to a source of information or opinion.\n
-To assess the contextual relevance of questions, information, principles, rules or
procedural directions.\n
-To assess the acceptability, the level of confidence to place in the probability or
truth of any given representation of an experience, situation, judgment, belief or opinion.")



evaluation.ct_subhabilities.create(name: 'Evaluar argumentos', description: "-To judge whether the assumed acceptability of the premises of a given argument
justify one's accepting as true (deductively certain), or very probably true (inductively
justified), the expressed conclusion of that argument.\n
-To anticipate or to raise questions or objections, and to assess whether these point
to significant weakness in the argument being evaluated.\n
-To determine whether an argument relies on false or doubtful assumptions or
presuppositions and then to determine how crucially these affect its strength.\n
-To judge between reasonable and fallacious inferences;\n
-To judge the probative strength of an argument's premises and assumptions with
a view toward determining the acceptability of the argument.\n
-To determine and judge the probative strength of an argument's intended or
unintended consequences with a view toward judging the acceptability of the argument.\n
-To determine the extent to which possible additional information might strengthen
or weaken an argument.")




inference.ct_subhabilities.create(name: 'Consultar evidencia', description: "-In particular, to recognize premises which require support and to formulate a
strategy for seeking and gathering information which might supply that support.\n
-In general, to judge that information relevant to deciding the acceptability,
plausibility or relative merits of a given alternative, question, issue, theory, hypothesis, or
statement is required, and to determine plausible
investigatory strategies for acquiring
that information.")

inference.ct_subhabilities.create(name: 'Conjeturar alternativas', description: "-To formulate multiple alternatives for resolving a problem, to postulate a series of
suppositions regarding a question, to project alternative hypotheses regarding an event, to
develop a variety of different plans to achieve some goal.\n
-To draw out presuppositions and project the range of possible consequences of
decisions, positions, policies, theories, or beliefs.")


inference.ct_subhabilities.create(name: 'Sacar conclusiones', description: "-To apply appropriate modes of inference in determining what position, opinion or
point of view one should take on a given matter or issue.\n
-Given a set of statements, descriptions, questions or other forms of representation,
to educe, with the proper level of logical strength, their inferential relationships and the
consequences or the presuppositions which they support, warrant, imply or entail.\n
-To employ successfully various sub-species of reasoning, as for example to reason
analogically, arithmetically, dialectically, scientifically, etc.\n
-To determine which of several possible conclusions is most strongly warranted or
supported by the evidence at hand, or which should be rejected
or regarded as less
plausible by the information given.")




explanation.ct_subhabilities.create(name: 'Presentar resultados', description: "To produce accurate statements, descriptions or representations of the results of
one's reasoning activities so as to analyze, evaluate, infer from, or monitor those results.")


explanation.ct_subhabilities.create(name: 'Justificar procedimientos', description: "To present the evidential, conceptual, methodological, criteriological and contextual
considerations which one used in forming one's interpretations, analyses, evaluation or
inferences, so that one might accurately record, evaluate, describe or justify those
processes to one's self or to others, or so as to remedy perceived deficiencies in the general
way one executes those processes.")

explanation.ct_subhabilities.create(name: 'Presentar argumentos', description: "-To give reasons for accepting some claim.\n
-To meet objections to the method, conceptualizations, evidence, criteria or
contextual appropriateness of inferential, analytical or evaluative judgments")


selfregulation.ct_subhabilities.create(name: 'Autoexaminación', description: "-To reflect on one's own reasoning and verify both the results produced and the
correct application and execution of the cognitive skills involved.\n
-To make an objective and thoughtful meta-cognitive self-assessment of one's
opinions and reasons for holding them.\n
-To judge the extent to which one's thinking is influenced by deficiencies in one's
knowledge, or by stereotypes, prejudices, emotions or any other factors which constrain
one's objectivity or rationality.\n
-To reflect on one's motivations, values, attitudes and interests with a view toward
determining that one has endeavored to be unbiased, fair-minded, thorough, objective, respectful of the truth, reasonable, and rational in coming to one's analyses, interpretations,
evaluations, inferences, or expressions.")

selfregulation.ct_subhabilities.create(name: 'Autocorreción', description: "Where self-examination reveals errors or deficiencies, to design reasonable
procedures to remedy or correct, if possible, those mistakes and their causes.")
