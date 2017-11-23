class Scorer
  attr_accessor :reply, :tree

  def initialize(tree)
    @tree = tree
  end

  def base
    {
      n:              0,
      content:        0,
      interpretation: 0,
      analysis:       0,
      evaluation:     0,
      inference:      0,
      explication:    0,
      selfregulation: 0
    }
  end

  def call
    temp = @tree
      .replies
      .map { |r| rate(r) }
      .reduce(base) do |agg, r|
        {
          n:              agg[:n]              + 1,
          content:        agg[:content]        + r[:content],
          interpretation: agg[:interpretation] + r[:interpretation],
          analysis:       agg[:analysis]       + r[:analysis],
          evaluation:     agg[:evaluation]     + r[:evaluation],
          inference:      agg[:inference]      + r[:inference],
          explication:    agg[:explication]    + r[:explication],
          selfregulation: agg[:selfregulation] + r[:selfregulation]
        }
      end
    
    n = temp[:n]
    {
      n:              n,
      content:        temp[:content]        / n.next,
      interpretation: temp[:interpretation] / n.next,
      evaluation:     temp[:evaluation]     / n.next,
      inference:      temp[:inference]      / n.next,
      explication:    temp[:explication]    / n.next,
      selfregulation: temp[:selfregulation] / n.next,
    }
  end

  def rate reply
    p, a = reply.picks, reply.attempts.count
    a    = a.zero? ? (reply.picks.incorrect.select("distinct date_trunc('second', picks.created_at)").count + 3) : a

    {
      n:              1,
      content:        p.content.correct.count.to_f / a,
      interpretation: p.of_type("Interpretación").select(&:right).count.to_f / a,
      analysis:       p.of_type("Análisis"      ).select(&:right).count.to_f / a,
      evaluation:     p.of_type("Evaluación"    ).select(&:right).count.to_f / a,
      inference:      p.of_type("Inferencia"    ).select(&:right).count.to_f / a,
      explication:    p.of_type("Explicación"   ).select(&:right).count.to_f / a,
      selfregulation: p.of_type("Autoregulación").select(&:right).count.to_f / a,
    }
  end
end