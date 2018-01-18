class ReplyFactory
  def create(tree, perfect=false)
    reply = tree.replies.build

    create_stage(reply, "initial",      perfect)
    create_stage(reply, "recuperative", perfect)
    create_stage(reply, "deeping",      perfect)

    reply
  end

  private
  def create_stage(reply, stage, perfect=false)
    reply.send("#{stage}!")
    attempt    = reply.attempts.build stage: stage

    cn_choices = reply.tree.send("#{stage}_content_question").choices
    ct_choices = reply.tree.send("#{stage}_ct_question").choices

    if perfect
      cn_choices = cn_choices.select(&:right)
      ct_choices = ct_choices.select(&:right)
    end

    attempt.picks.build reply: reply, selectable: cn_choices.sample
    attempt.picks.build reply: reply, selectable: ct_choices.sample
  end
end