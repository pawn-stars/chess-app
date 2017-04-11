require 'rails_helper'

RSpec.describe Knight, type: :model do
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
    let(:white_row) { 2 }
    let(:white_col) { 2 }
    let(:black_row) { 5 }
    let(:black_col) { 5 }

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
        row: white_row, col: white_col, type: Knight, is_black: false, user: @white
      )
      # square: 5,5
      black_knight = @game.pieces.create(
        row: black_row, col: black_col, type: Knight, is_black: true, user: @black
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
