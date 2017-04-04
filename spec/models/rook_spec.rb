require 'rails_helper'
RSpec.describe Rook, type: :model do
  describe "#valid_move?" do
    let(:rook) { Rook.create(row: 0, col: 1) }

    it "should allow legal vertical moves" do
      expect(rook.move_legal?(1, 1)).to be true
    end

    it "should allow legal horizontal moves" do
      expect(rook.move_legal?(0, 0)).to be true
    end

    it "should not allow an illegal move" do
      expect(rook.move_legal?(2, 2)).to be false
    end
  end
end
