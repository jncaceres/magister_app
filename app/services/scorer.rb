class Scorer
  attr_accessor :reply, :tree

  def initialize(tree)
    @tree = Tree.includes(replies: { attempts: :picks }).find tree.id
  end

  def call
    scores = @tree.replies.map do |reply|
      score_reply(reply)
    end

    scores.reduce(@@base) do |agg, elem| reducer(agg, elem) end
  end

  # private
  @@attrs  = %i(content interpretation analysis evaluation inference explication selfregulation)
  @@stages = %w(initial recuperative deeping)
  @@base   = {
    n:              1.0,
    content:        0.0,
    interpretation: 0.0,
    analysis:       0.0,
    evaluation:     0.0,
    inference:      0.0,
    explication:    0.0,
    selfregulation: 0.0
  }

  def score_reply(reply)
    scores = @@stages.map do |stage|
      score_stage(reply, stage)
    end.compact

    @@attrs.reduce(@@base) do |acc, att|
      scs = scores.map do |sc| sc[att] end.compact
      
      acc.merge(att => (scs.empty? ? 0.0 : scs.sum / scs.count.to_f))
    end
  end

  def score_stage(reply, stage)
    reply
      .attempts
      .select do |att| att.send(stage + "?") end
      .map    do |att| score_attempt(att, stage) end
      .reduce(&:merge)
  end

  def score_attempt(attempt, stage)
    cn_score = score_question @tree.send("#{stage}_content_question"), attempt.picks.content
    ct_score = score_question @tree.send("#{stage}_ct_question"),      attempt.picks.ct

    @tree
      .send("#{stage}_ct_question")
      .ct_habilities
      .actives
      .map(&:name)
      .reduce({ content: cn_score }) do |agg, ct|
        agg.merge(symbolify(ct) => ct_score)
      end
  end

  def score_question(question, picks)
    rights = question.choices.select(&:right)
    rights.empty? ? 0.0 : (picks.correct.count / rights.count.to_f)
  end

  def score_pick(pick)
    pick.right ? 1 : 0
  end

  def reducer(acc, score)
    @@attrs.reduce({ n: acc[:n] + score[:n] }) do |agg, att|
      agg.merge(att => ponderate(acc, score, att))
    end
  end

  def ponderate(accum, score, att)
    x = accum[att] * accum[:n]
    y = score[att] * score[:n]

    (x + y) / (accum[:n] + score[:n])
  end

  def symbolify(str)
    case str
      when "Interpretación" then :interpretation
      when "Análisis"       then :analysis
      when "Evaluación"     then :evaluation
      when "Inferencia"     then :inference
      when "Explicación"    then :explication
      when "Autoregulación" then :selfregulation
      else                       :error
    end
  end
end