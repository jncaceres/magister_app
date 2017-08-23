require 'rails_helper'

describe Scorer do
  describe "#call" do
    before do
      reply   = Reply.new
      @scorer = Scorer.new reply
    end

    it "works" do
      expect(2 + 2).to eq(4)
    end
  end
end