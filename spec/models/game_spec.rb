require 'rails_helper'

RSpec.describe Game, type: :model do
  context "associations" do
    it { should have_many(:participations) }
    it { should have_many(:pieces) }
  end

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
      Game.create
      expect(Game.available.count).to eq(0)
    end
  end
end
