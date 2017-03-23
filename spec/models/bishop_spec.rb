require 'rails_helper'

RSpec.describe Bishop, type: :model do
  describe '#move_legal?' do
    let(:bishop) { Bishop.create(row: 3, col: 3) }

    it "is legal" do
      expect(bishop.move_legal?(4, 4)).to be true
    end

    it "is not legal" do
      expect(bishop.move_legal?(4, 5)).to be false
    end
  end
end
