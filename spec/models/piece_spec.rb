require 'rails_helper'

RSpec.describe Piece, type: :model do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:game) }
    it { should have_many(:moves) }
  end

  describe "#move_to!" do
    before(:all) do
      User.delete_all
      Game.delete_all
      Move.delete_all

      @user = User.create(
        email: 'foobar@foobar.com',
        screen_name: 'foobar',
        password: 'foobar',
        password_confirmation: 'foobar'
      )

      @game = @user.games.create(white_player_id: @user)
    end

    before(:each) do
      Piece.delete_all
    end

    it "should update row and col attributes" do
      piece = @game.pieces.create(
        row: 0, col: 0, is_captured: false, user: @user
      )
      piece.move_to!(7, 7)

      expect(piece.row).to eq(7)
      expect(piece.col).to eq(7)
    end

    it "should create a new move" do
      piece = @game.pieces.create(
        row: 0, col: 0, is_captured: false, user: @user
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

    # PRIVATE method move_nil?
    it "tests private method move_nil? with a nil move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_nil?, FROM_ROW, FROM_COL)).to be true
    end
    it "tests private method move_nil? with a non-nil move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_nil?, 7, 7)).to be false
    end

    # PRIVATE method move_out_bounds
    it "tests private method move_out_of_bounds? with an off-board move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_out_of_bounds?, FROM_ROW, 8)).to be true
    end
    it "tests private method move_out_of_bounds? with an on-board move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_out_of_bounds?, FROM_ROW + 1, FROM_COL + 1)).to be false
    end

    # Private method valid_move?
    it "tests private method valid_move? with a nil move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:valid_move?, FROM_ROW, FROM_COL)).to be false
    end

    it "tests private method valid_move? with an out of bounds move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:valid_move?, FROM_ROW, 8)).to be false
    end

    # move_to! with an out-of-bounds move
    it "should not move the piece out of bounds" do
      to_col = 8
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      piece.move_to!(FROM_ROW, to_col)
      expect(piece.row).to eq(FROM_ROW)
      expect(piece.col).to eq(FROM_COL)
    end

    # remove test after all piece subclass tests complete
    it "should not move the piece due to illegal move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      piece.move_to!(FROM_ROW + 2, FROM_COL + 1)
      expect(piece.row).to eq(FROM_ROW)
      expect(piece.col).to eq(FROM_COL)
    end
    # remove test after all piece subclass tests complete
    it "should move the piece: horizonal move" do
      to_col = 7
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      piece.move_to!(FROM_ROW, to_col)
      expect(piece.row).to eq(FROM_ROW)
      expect(piece.col).to eq(to_col)
    end
    # remove test after all piece subclass tests complete
    it "should move the piece: vertical move" do
      to_row = 7
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      piece.move_to!(to_row, FROM_COL)
      expect(piece.row).to eq(to_row)
      expect(piece.col).to eq(FROM_COL)
    end
    # remove test after all piece subclass tests complete
    it "should move the piece: diagonal move" do
      to_row = 6
      to_col = 5
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      piece.move_to!(to_row, to_col)
      expect(piece.row).to eq(to_row)
      expect(piece.col).to eq(to_col)
    end
  end

  describe "#capture" do
    before(:all) do
      User.delete_all
      Game.delete_all
      Piece.delete_all

      @user1 = User.create(
        email: 'foobar@foobar.com',
        screen_name: 'foobar',
        password: 'foobar',
        password_confirmation: 'foobar'
      )
      @user2 = User.create(
        email: 'black@foobar.com',
        screen_name: 'black',
        password: 'foobar',
        password_confirmation: 'foobar'
      )

      @game = @user1.games.create(
        white_player_id: @user1,
        black_player_id: @user2
      )
    end

    it "should capture a piece" do
      piece1 = @user1.pieces.create(row: 0, col: 0, game_id: @game.id)
      piece2 = @user2.pieces.create(
        row: 0,
        col: 1,
        is_captured: false,
        game_id: @game.id
      )
      expect(piece1.capture_piece(0, 1)).to eq(true)
      piece2.reload
      expect(piece2.captured?).to eq(true)
    end

    it "should not capture a player's own piece" do
      piece1 = @user1.pieces.create(row: 0, col: 0, game_id: @game.id)
      piece2 = @user1.pieces.create(
        row: 0,
        col: 1,
        is_captured: false,
        game_id: @game.id
      )
      expect { piece1.capture_piece(0, 1) }.to raise_error(RuntimeError)
      piece2.reload # fetch it from the DB again
      expect(piece2.captured?).to eq(false)
    end
  end
end
