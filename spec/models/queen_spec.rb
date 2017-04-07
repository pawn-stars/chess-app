require 'rails_helper'

RSpec.describe Queen, type: :model do
  WHITE_ROW = 0
  BLACK_ROW = 7
  COL = 3

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
        row: WHITE_ROW, col: COL, type: Queen, user: @white
      )
      black_queen = @game.pieces.create(
        row: BLACK_ROW, col: COL, type: Queen, user: @black
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
end
