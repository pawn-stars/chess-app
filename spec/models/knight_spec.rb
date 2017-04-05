require 'rails_helper'

RSpec.describe Knight, type: :model do
  WHITE_ROW = 2
  WHITE_COL = 2
  BLACK_ROW = 5
  BLACK_COL = 5

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
    def row_two(knight)
      knight.is_black ? -2 : 2
    end

    def row_one(knight)
      knight.is_black ? -1 : 1
    end

    def col_two(knight)
      knight.is_black ? -2 : 2
    end

    def col_one(knight)
      knight.is_black ? -1 : 1
    end

    before(:example) do
      Piece.delete_all
      # square: 2,2
      white_knight = @game.pieces.create(
        row: WHITE_ROW, col: WHITE_COL, type: Knight, is_black: false, user: @white
      )
      # square: 5,5
      black_knight = @game.pieces.create(
        row: BLACK_ROW, col: BLACK_COL, type: Knight, is_black: true, user: @black
      )
      @knights = [white_knight, black_knight]
    end

    it "allows 1 row, 2 columns" do
      @knights.each do |knight|
        to_row = knight.row + row_one(knight)
        to_col = knight.col + col_two(knight)
        expect(knight.move_legal?(to_row, to_col)).to be true
      end
    end

    it "allows 2 rows, 1 column" do
      @knights.each do |knight|
        to_row = knight.row + row_two(knight)
        to_col = knight.col + col_one(knight)
        expect(knight.move_legal?(to_row, to_col)).to be true
      end
    end

    it "tests move_obstructed?" do
      to_row = @knights[0].row + row_one(@knights[0])
      to_col = @knights[0].col + col_two(@knights[0])
      expect(@knights[0].move_obstructed?(to_row, to_col)).to be false
    end
  end
end
