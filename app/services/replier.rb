class Replier
  attr_accessor :reply

  def initialize(reply)
    @reply = reply
  end

  def stage
    reply.stage
  end

  def next
    return if reply.finished? # Already done
  end
end