require 'rails_helper'

RSpec.describe Queen, type: :model do
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
      white_player_id: @white,
      black_player_id: @black
    )
    @black.games << @game
  end

  after(:all) do
    DatabaseCleaner.clean_with(:deletion)
  end

  describe '#move_legal?' do
    let(:white_row) { 0 }
    let(:black_row) { 7 }
    let(:col) { 3 }

    def row_move(queen)
      queen.is_black ? -5 : 5
    end

    def col_move(queen)
      queen.is_black ? 4 : -3
    end

    def diagonal_move(queen)
      queen.is_black ? -2 : 2
    end

    before(:example) do
      Piece.delete_all
      white_queen = @game.pieces.create(
        row: white_row, col: col, type: Queen, user: @white
      )
      black_queen = @game.pieces.create(
        row: black_row, col: col, type: Queen, user: @black
      )
      @queens = [white_queen, black_queen]
    end

    it "allows horizontal move" do
      @queens.each do |queen|
        to_row = queen.row + row_move(queen)
        to_col = queen.col
        expect(queen.move_legal?(to_row, to_col)).to be true
      end
    end

    it "allows vertical move" do
      @queens.each do |queen|
        to_row = queen.row
        to_col = queen.col + col_move(queen)
        expect(queen.move_legal?(to_row, to_col)).to be true
      end
    end

    it "allows diagonal move" do
      @queens.each do |queen|
        to_row = queen.row + diagonal_move(queen)
        to_col = queen.col + diagonal_move(queen)
        expect(queen.move_legal?(to_row, to_col)).to be true
      end
    end
  end

  describe "path_to_king" do
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
