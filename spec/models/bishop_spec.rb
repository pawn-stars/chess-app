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
      bishop = @black.pieces.create(
        type: 'Bishop', row: 0, col: 6, game_id: @game.id, is_black: true
      )
      expect(bishop.path_to_king).to be_nil
    end

    it "creates a path to the enemy king" do
      bishop = @black.pieces.create(
        type: 'Bishop', row: 6, col: 6, game_id: @game.id, is_black: true
      )
      path = [[5, 5], [4, 4], [3, 3], [2, 2], [1, 1]]
      expect(bishop.path_to_king).to eq(path)
    end
  end
end
