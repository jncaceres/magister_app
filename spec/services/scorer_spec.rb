require 'rails_helper'

describe Scorer do
  describe "#call" do
    before do
      tree    = Tree.new
      @reply  = tree.replies.build
      @reply.attempts.build
      choice  = CtChoice.new
      choice.ct_habilities.build name: "interpretation", active: true
      @reply.picks.build selectable: choice
      @scorer = Scorer.new tree
    end

    it "works" do
      expect(2 + 2).to eq(4)
    end

    it "produces passable results" do
      expect(@scorer.call[:content]).to be_a(Float)
    end

    it "supports the queries I need" do
      expect(@reply.picks.of_type("interpretation").to_a).not_to be_empty
    end
  end
end