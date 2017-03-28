require 'rails_helper'
RSpec.describe Rook, type: :model do
  describe "#valid_move?" do
    before(:all) do
      User.delete_all
      Game.delete_all
      Piece.delete_all

      @user1 = User.create(
        email: 'foobar@foobar.com',
        screen_name: 'foobar',
        password: 'foobar',
        password_confirmation: 'foobar'
      )
      @user2 = User.create(
        email: 'black@foobar.com',
        screen_name: 'black',
        password: 'foobar',
        password_confirmation: 'foobar'
      )

      @game = @user1.games.create(
        white_player_id: @user1,
        black_player_id: @user2
      )
    end

    it "should allow legal vertical moves" do
      rook = Rook.create(row: 0, col: 1, game_id: @game.id)
      expect(rook.valid_move?(1, 1)).to eq(true)
    end

    it "should allow legal horizontal moves" do
      rook = Rook.create(row: 0, col: 1)
      expect(rook.valid_move?(0, 0)).to eq(true)
    end
  end
end
