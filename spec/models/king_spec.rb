require 'rails_helper'

RSpec.describe King, type: :model do
  describe '#move_legal?' do
    from_row = 0
    from_col = 4

    let(:king) { King.create(row: from_row, col: from_col) }

    it "allows King legal move: horizontal" do
      expect(king.move_legal?(from_row, from_col + 1)).to be true
    end

    it "allows legal move: vertical" do
      king.update_attributes(row: from_row, col: from_col)
      expect(king.move_legal?(from_row + 1, from_col)).to be true
    end

    it "allows legal move: diagonal" do
      king.update_attributes(row: from_row, col: from_col)
      expect(king.move_legal?(from_row + 1, from_col + 1)).to be true
    end

    it "does not allow not legal move" do
      king.update_attributes(row: from_row, col: from_col)
      expect(king.move_legal?(from_row + 2, from_col + 3)).to be false
    end
  end
end
