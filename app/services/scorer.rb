class Scorer
  attr_accessor :reply, :tree

  def initialize(tree)
    @tree = tree
  end

  def call
    @tree
      .replies
      .map { |r| rate(r) }
      .reduce do |agg, r|
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
  end

  def rate reply
    # TODO: implement    
    {
      content:        0,
      interpretation: 0,
      analysis:       0,
      evaluation:     0,
      inference:      0,
      explication:    0,
      selfregulation: 0
    }
  end
end