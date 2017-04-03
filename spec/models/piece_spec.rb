require 'rails_helper'

RSpec.describe Piece, type: :model do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:game) }
    it { should have_many(:moves) }
  end

  describe "#move_to!" do
    before(:all) do
      @user = User.create(
        email: 'foobar@foobar.com',
        screen_name: 'foobar',
        password: 'foobar',
        password_confirmation: 'foobar'
      )
      @game = @user.games.create(white_player_id: @user)
    end

    after(:all) do
      DatabaseCleaner.clean_with(:deletion)
    end

    before(:example) do
      Piece.delete_all
    end

    it "should update row and col attributes" do
      piece = @game.pieces.create(
        row: 0, col: 0, user: @user
      )
      piece.move_to!(7, 7)

      expect(piece.row).to eq(7)
      expect(piece.col).to eq(7)
    end

    it "should create a new move" do
      piece = @game.pieces.create(
        row: 0, col: 0, user: @user
      )
      piece.move_to!(7, 7)
      move = piece.moves.last

      expect(move.move_number).to eq(1)
      expect(move.from_position).to eq([0, 0])
      expect(move.to_position).to eq([7, 7])
      expect(move.game_id).to eq(@game.id)
    end

    # MeO tests for move_to! - test valid_move? and its called methods
    FROM_ROW = 3
    FROM_COL = 2

    describe "#move_nil?" do
      it "tests private method move_nil? with a nil move" do
        piece = @game.pieces.create(
          row: FROM_ROW, col: FROM_COL, user: @user
        )
        expect(piece.send(:move_nil?, FROM_ROW, FROM_COL)).to be true
      end

      it "tests private method move_nil? with a non-nil move" do
        piece = @game.pieces.create(
          row: FROM_ROW, col: FROM_COL, user: @user
        )
        expect(piece.send(:move_nil?, 7, 7)).to be false
      end
    end

    describe "#move_out_bounds?" do
      it "tests private method move_out_of_bounds? with an off-board move" do
        piece = @game.pieces.create(
          row: FROM_ROW, col: FROM_COL, user: @user
        )
        expect(piece.send(:move_out_of_bounds?, FROM_ROW, 8)).to be true
      end

      it "tests private method move_out_of_bounds? with an on-board move" do
        piece = @game.pieces.create(
          row: FROM_ROW, col: FROM_COL, user: @user
        )
        expect(piece.send(:move_out_of_bounds?, FROM_ROW + 1, FROM_COL + 1)).to be false
      end
    end

    describe "#valid_move?" do
      it "tests private method valid_move? with a nil move" do
        piece = @game.pieces.create(
          row: FROM_ROW, col: FROM_COL, user: @user
        )
        expect(piece.send(:valid_move?, FROM_ROW, FROM_COL)).to be false
      end

      it "tests private method valid_move? with an out of bounds move" do
        piece = @game.pieces.create(
          row: FROM_ROW, col: FROM_COL, user: @user
        )
        expect(piece.send(:valid_move?, FROM_ROW, 8)).to be false
      end
    end

    # This should be integrated into the '#move_to!' group
    # move_to! with an out-of-bounds move
    it "should not move the piece out of bounds" do
      to_col = 8
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, user: @user
      )
      piece.move_to!(FROM_ROW, to_col)
      expect(piece.row).to eq(FROM_ROW)
      expect(piece.col).to eq(FROM_COL)
    end

    # remove after all piece subclass tests complete
    describe "#move_legal?" do
      it "should not move the piece due to illegal move" do
        piece = @game.pieces.create(
          row: FROM_ROW, col: FROM_COL, user: @user
        )
        piece.move_to!(FROM_ROW + 2, FROM_COL + 1)
        expect(piece.row).to eq(FROM_ROW)
        expect(piece.col).to eq(FROM_COL)
      end

      it "should move the piece: horizonal move" do
        to_col = 7
        piece = @game.pieces.create(
          row: FROM_ROW, col: FROM_COL, user: @user
        )
        piece.move_to!(FROM_ROW, to_col)
        expect(piece.row).to eq(FROM_ROW)
        expect(piece.col).to eq(to_col)
      end

      it "should move the piece: vertical move" do
        to_row = 7
        piece = @game.pieces.create(
          row: FROM_ROW, col: FROM_COL, user: @user
        )
        piece.move_to!(to_row, FROM_COL)
        expect(piece.row).to eq(to_row)
        expect(piece.col).to eq(FROM_COL)
      end

      it "should move the piece: diagonal move" do
        to_row = 6
        to_col = 5
        piece = @game.pieces.create(
          row: FROM_ROW, col: FROM_COL, user: @user
        )
        piece.move_to!(to_row, to_col)
        expect(piece.row).to eq(to_row)
        expect(piece.col).to eq(to_col)
      end
    end
  end

  describe "#capture_piece" do
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

    it "should capture a piece" do
      piece1 = @white.pieces.create(row: 0, col: 0, game_id: @game.id, is_black: false)
      piece2 = @black.pieces.create(
        row: 0,
        col: 1,
        game_id: @game.id,
        is_black: true
      )
      expect(piece1.capture_piece(0, 1)).to be_truthy
      piece2.reload
      expect(piece2.captured?).to be_truthy
    end

    it "should not capture a player's own piece" do
      piece1 = @white.pieces.create(row: 0, col: 0, game_id: @game.id, is_black: false)
      piece2 = @white.pieces.create(
        row: 0,
        col: 1,
        game_id: @game.id,
        is_black: false
      )
      piece1.capture_piece(0, 1)
      piece2.reload
      expect(piece2.captured?).to be_falsey
    end
  end
end
