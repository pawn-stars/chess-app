require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should have_many(:participations) }

  describe "#available" do
    it "should include games with one player" do
      Game.create(white_player_id: 1)
      Game.create(black_player_id: 1)
      expect(Game.available.count).to eq(2)
    end

    it "should exclude games with two players" do
      Game.create(white_player_id: 1, black_player_id: 2)
      expect(Game.available.count).to eq(0)
    end

    it "should exclude games with zero players" do
      Game.create()
      expect(Game.available.count).to eq(0)
    end
  end
end
