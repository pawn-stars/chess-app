require 'rails_helper'

RSpec.describe Queen, type: :model do
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
      queen = @black.pieces.create(
        type: 'Queen', row: 1, col: 7, game_id: @game.id, is_black: true
      )
      expect(queen.path_to_king).to be_nil
    end

    it "creates a straight path to the enemy king" do
      queen = @black.pieces.create(
        type: 'Queen', row: 0, col: 7, game_id: @game.id, is_black: true
      )
      path = [[0, 6], [0, 5], [0, 4], [0, 3], [0, 2], [0, 1]]
      expect(queen.path_to_king).to eq(path)
    end

    it "creates a diagonal path to the enemy king" do
      queen = @black.pieces.create(
        type: 'Queen', row: 6, col: 6, game_id: @game.id, is_black: true
      )
      path = [[5, 5], [4, 4], [3, 3], [2, 2], [1, 1]]
      expect(queen.path_to_king).to eq(path)
    end
  end
end
