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

  describe "path_to_king" do
    before(:all) do
      @white = User.create(
        email: 'white@foobar.com',
        screen_name: 'white',
        password: 'foobar',
        password_confirmation: 'foobar'
      )
      @black = User.create(
        email: 'black@foobar.com',
        screen_name: 'black',
        password: 'foobar',
        password_confirmation: 'foobar'
      )
      @game = @white.games.create(
        white_player_id: @white.id,
        black_player_id: @black.id
      )
      @black.games << @game
    end

    after(:all) do
      DatabaseCleaner.clean_with(:deletion)
    end

    before(:example) do
      Piece.delete_all
      @white_king = @white.pieces.create(
        type: 'King', row: 0, col: 0, game_id: @game.id, is_black: false
      )
      @black_king = @black.pieces.create(
        type: 'King', row: 7, col: 7, game_id: @game.id, is_black: true
      )
    end

    it "returns nil if the enemy king is not in any path" do
      rook = @black.pieces.create(
        type: 'Rook', row: 1, col: 7, game_id: @game.id, is_black: true
      )
      expect(rook.path_to_king).to be_nil
    end

    it "creates a path to the enemy king" do
      rook = @black.pieces.create(
        type: 'Rook', row: 0, col: 7, game_id: @game.id, is_black: true
      )
      path = [[0, 6], [0, 5], [0, 4], [0, 3], [0, 2], [0, 1]]
      expect(rook.path_to_king).to eq(path)
    end
  end
end
