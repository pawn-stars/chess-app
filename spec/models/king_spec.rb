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
        Move.delete_all

        white_king = @game.pieces.create(
          row: WHITE_ROW, col: COL, type: King, is_black: false, user: @white
        )
        black_king = @game.pieces.create(
          row: BLACK_ROW, col: COL, type: King, is_black: false, user: @black
        )
        @kings = [white_king, black_king]

        white_rook = @game.pieces.create(
          row: WHITE_ROW, col: ROOK_COL_RIGHT, type: Rook, is_black: false, user: @white
        )
        black_rook = @game.pieces.create(
          row: BLACK_ROW, col: ROOK_COL_LEFT, type: Rook, is_black: true, user: @black
        )
        @rooks = [white_rook, black_rook]
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

      it "should not allow king to castle right with no rook" do
        @rooks[0].update_attributes(row: -1, col: -1)
        @rooks[1].update_attributes(row: -1, col: -1)
        expect(@kings[0].move_legal?(WHITE_ROW, COL + 2)).to be_falsey
      end

      it "should allow king to castle right or king-side" do
        expect(@kings[0].move_legal?(WHITE_ROW, COL + 2)).to be true
      end

      it "should allow king to castle left or queen-side" do
        expect(@kings[1].move_legal?(BLACK_ROW, COL - 2)).to be true
      end

      # rubocop:disable UselessAssignment
      it "should not allow king to castle right when path obstructed" do
        bishop_right = @game.pieces.create(
          row: WHITE_ROW, col: COL + 1, type: Bishop, is_black: false, user: @white
        )
        expect(@kings[0].move_legal?(WHITE_ROW, COL + 2)).to be false
      end

      it "should not allow king to castle left when path obstructed" do
        queen = @game.pieces.create(
          row: BLACK_ROW, col: COL - 1, type: queen, is_black: true, user: @black
        )
        expect(@kings[1].move_legal?(BLACK_ROW, COL - 2)).to be false
      end

      # move_to! tests to verify that first move for king and/or rook

      it "should not allow king to castle since not first king move" do
        king_move = @game.moves.create(
          move_number: 1,
          from_position: [WHITE_ROW, COL],
          to_position: [WHITE_ROW + 1, COL + 1],
          piece_id: @kings[0].id,
          game_id: @game.id
        )
        expect(@kings[0].move_to!(WHITE_ROW, COL + 2)).to be false
      end

      it "should not allow king to castle since not first rook move" do
        Move.delete_all
        rook_move = @game.moves.create(
          move_number: 1,
          from_position: [BLACK_ROW, ROOK_COL_LEFT],
          to_position: [BLACK_ROW - 4, ROOK_COL_LEFT],
          piece_id: @rooks[1].id,
          game_id: @game.id
        )
        expect(@kings[1].move_to!(BLACK_ROW, COL - 2)).to be false
      end
    end
  end
end
