require 'rails_helper'

RSpec.describe Bishop, type: :model do
  describe '#move_legal?' do
    let(:bishop) { Bishop.create(row: 3, col: 3) }

    it "allows legal moves" do
      expect(bishop.move_legal?(6, 6)).to be true
    end

    it "does not allow not legal moves" do
      expect(bishop.move_legal?(4, 5)).to be false
    end
  end
end
