require 'rails_helper'

class ReplyMock
  attr_accessor :stage

  def initialize(stage="initial", right=true)
    @stage = stage
    @right = right
  end

  def correct!
    @right = true
  end

  def incorrect!
    @right = false
  end

  def initial?
    @stage == "initial"
  end

  def recuperative?
    @stage == "recuperative"
  end

  def deeping?
    @stage == "deeping"
  end

  def finished?
    @stage == "finished"
  end

  def initial!
    @stage = "initial"
  end

  def recuperative!
    @stage = "recuperative"
  end

  def deeping!
    @stage = "deeping"
  end

  def finished!
    @stage = "finished"
  end
end

describe Replier do
  describe "#call" do
    it "works?" do
      reply   = ReplyMock.new
      replier = Replier.new(reply)

      expect(replier).to be_a Replier
      expect(replier).to respond_to(:stage)
      expect(replier).to respond_to(:next)
    end

    it "informs of its current stage" do
      reply   = ReplyMock.new
      replier = Replier.new(reply)

      expect(replier.stage).to eq "initial"
    end
    
    it "advances from initial to profundization stage when replies are correct" do
      reply   = ReplyMock.new "initial", true
      replier = Replier.new(reply)

      expect(replier.stage).to eq "initial"
      replier.next
      expect(replier.stage).to eq "deeping"
    end

    it "advances from initial to recuperative stage when replies are incorrect" do
      reply   = ReplyMock.new "initial", false
      replier = Replier.new(reply)

      expect(replier.stage).to eq "initial"
      replier.next
      expect(replier.stage).to eq "recuperative"
    end

    it "advances to deeping even on incorrect replies" do
      reply   = ReplyMock.new "recuperative", false
      replier = Replier.new(reply)

      expect(replier.stage).to eq "recuperative"
      replier.next
      expect(replier.stage).to eq "deeping"
    end

    it "does nothing on a finished reply" do
      reply   = ReplyMock.new "finished", true
      replier = Replier.new(reply)

      expect(replier.stage).to eq "finished"
      replier.next
      expect(replier.stage).to eq "finished"
    end
  end
end