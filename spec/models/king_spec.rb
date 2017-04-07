require 'rails_helper'

RSpec.describe King, type: :model do
  describe '#move_legal?' do
    WHITE_ROW = 0
    BLACK_ROW = 7
    COL = 4
    ROOK_COL_RIGHT = 7
    ROOK_COL_LEFT = 0

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

    describe "move_legal?" do
      def row_move(king)
        king.is_black ? -1 : 1
      end
      def col_move(king)
        king.is_black ? 1 : -1
      end

      before(:example) do
        Piece.delete_all
        white_king = @game.pieces.create(
          row: WHITE_ROW, col: COL, type: King, is_black: false, user: @white
        )
        black_king = @game.pieces.create(
          row: BLACK_ROW, col: COL, type: King, is_black: false, user: @black
        )
        @kings = [white_king,black_king]
      end

      it "allows King legal move: horizontal" do
        @kings.each do |king|
          to_row = king.row + row_move(king)
          to_col = king.col
          expect(king.move_legal?(to_row, to_col)).to be true
        end
      end

      it "allows King legal move: vertical" do
        @kings.each do |king|
          to_row = king.row
          to_col = king.col + col_move(king)
          expect(king.move_legal?(to_row, to_col)).to be true
        end
      end

      it "allows King legal move: diagonal" do
        @kings.each do |king|
          to_row = king.row + row_move(king)
          to_col = king.col + col_move(king)
          expect(king.move_legal?(to_row, to_col)).to be true
        end
      end

      it "does not allow illegal move" do
        @kings.each do |king|
          to_row = king.row + row_move(king)
          to_col = king.col + 3
          expect(king.move_legal?(to_row, to_col)).to be false
        end
      end

      if "should allow king to castle right or king-side" do
        king = @kings[0]
        rook_right = @game.pieces.create(
          row: WHITE_ROW, COL: ROOK_COL_RIGHT, type: Rook, is_black: false, user: @white
        )
        expect(king.move_legal?(to_row, 6)).to be true
      end
    end
  end
end
