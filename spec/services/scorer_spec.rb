require 'rails_helper'

describe Scorer do
  describe "#call" do
    before do
      @tree   = TreeFactory.new.create
      @reply  = ReplyFactory.new.create(@tree, true)

      @tree.save
      @reply.save

      @scorer = Scorer.new @tree
    end

    it "works?" do
      expect(2 + 2).to equal(4)
      expect(@tree.errors).to be_empty
      expect(@reply.errors).to be_empty
      expect(@reply.attempts).not_to be_empty
      expect(@reply.attempts.initial).not_to be_empty
    end

    it "scores a single pick properly" do
      expect(@scorer.score_pick @reply.picks.first).to eq(1.0)
    end

    it "scores a single question properly" do
      question = @tree.initial_content_question
      picks    = @reply.attempts.initial.first.picks.content
      
      expect(@scorer.score_question question, picks).to eq(1.0)
    end

    it "scores a single attempt properly" do
      expect(@scorer.score_attempt @reply.attempts.initial.first, "initial").to include(content: 1.0)
    end

    it "scores a single stage properly" do
      expect(@scorer.score_stage(@reply, "initial")).to include(content: 1.0)
      @scorer.score_stage(@reply, "initial").each_pair do |k,v|
        expect(v).to eq(1.0)
      end
    end

    it "scores a single reply properly" do
      expect(@scorer.score_reply @reply).to include(content: 1.0)
    end

    it "scores a single tree properly" do
      pending "still unfinished"

      expect(@scorer.score_pick @reply.picks.first).to eq(1.0)
    end
  end
end