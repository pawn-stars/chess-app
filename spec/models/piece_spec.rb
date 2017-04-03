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
      FROM_ROW = 3
      FROM_COL = 2
      MOVE_ROW = 6
      MOVE_COL = 1
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

    # MeO tests for move_to! - test private valid_move? and its called methods

<<<<<<< HEAD
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
=======
    # private method move_nil?
    it "tests move_nil? with a nil move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_nil?, FROM_ROW, FROM_COL)).to be true
    end
    it "tests move_nil? with a valid move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_nil?, 7, 7)).to be false
    end

    # private method move_out_bounds
    it "tests move_out_of_bounds? with an off-board move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_out_of_bounds?, FROM_ROW, 8)).to be true
    end
    it "tests move_out_of_bounds? with an on-board move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_out_of_bounds?, FROM_ROW + 1, FROM_COL + 1)).to be false
    end

    # private method move_destination_same_side?
    it "tests move_destination_same_side? with empty destination square" do
      piece = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_destination_same_side?, MOVE_ROW - 4, MOVE_COL)).to be nil
    end

    it "tests move_destination_same_side? with same side piece at destination" do
      piece1 = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL, is_captured: false, is_black: true, user: @user
      )
      piece2 = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL + 4, is_captured: false, is_black: true, user: @user
      )
      expect(piece1.send(:move_destination_same_side?, MOVE_ROW, MOVE_COL + 4)).to be true
    end

    it "tests move_destination_same_side? with other side piece at destination" do
      piece1 = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL, is_captured: false, is_black: true, user: @user
      )
      piece2 = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL + 4, is_captured: false, is_black: false, user: @user
      )
      expect(piece1.send(:move_destination_same_side?, MOVE_ROW, MOVE_COL + 4)).to be false
    end

    # private method move_obstructed
    it "tests move_obstructed with horizontal move and no obstruction" do
      piece = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_obstructed?, MOVE_ROW, MOVE_COL + 6)).to be false
    end

    it "tests move_obstructed with horizontal move and obstruction" do
      piece1 = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL, is_captured: false, user: @user
      )
      piece2 = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL + 2, is_captured: false, user: @user
      )
      expect(piece1.send(:move_obstructed?, MOVE_ROW, MOVE_COL + 6)).to be true
    end

    it "tests move_obstructed with vertical move and no obstruction" do
      piece = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_obstructed?, MOVE_ROW - 4, MOVE_COL)).to be false
    end

    it "tests move_obstructed with vertical move and obstruction" do
      piece1 = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL, is_captured: false, user: @user
      )
      piece2 = @game.pieces.create(
        row: MOVE_ROW - 2, col: MOVE_COL, is_captured: false, user: @user
      )
      expect(piece1.send(:move_obstructed?, MOVE_ROW - 4, MOVE_COL)).to be true
    end

    it "tests move_obstructed with diagonal move and no obstruction" do
      piece = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL, is_captured: false, user: @user
      )
      expect(piece.send(:move_obstructed?, MOVE_ROW - 4, MOVE_COL + 4)).to be false
    end

    it "tests move_obstructed with diagonal move and obstruction" do
      piece1 = @game.pieces.create(
        row: MOVE_ROW, col: MOVE_COL, is_captured: false, user: @user
      )
      piece2 = @game.pieces.create(
        row: MOVE_ROW - 2, col: MOVE_COL + 2, is_captured: false, user: @user
      )
      expect(piece1.send(:move_obstructed?, MOVE_ROW - 4, MOVE_COL + 4)).to be true
    end

    # Private method valid_move?
    it "tests valid_move? with a nil move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:valid_move?, FROM_ROW, FROM_COL)).to be false
    end

    it "tests valid_move? with an out of bounds move" do
      piece = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, user: @user
      )
      expect(piece.send(:valid_move?, FROM_ROW, 8)).to be false
    end

    it "tests valid_move? with same side piece at destination" do
      piece1 = @game.pieces.create(
        row: FROM_ROW, col: FROM_COL, is_captured: false, is_black: true, user: @user
      )
      piece2 = @game.pieces.create(
        row: FROM_ROW + 3, col: FROM_COL + 3, is_captured: false, is_black: true, user: @user
      )
      expect(piece1.send(:valid_move?, FROM_ROW + 3, FROM_ROW + 3)).to be false
    end

    it "tests method valid_move? with a diagonal obstructed move" do
      row = 6
      col = 1
      piece1 = @game.pieces.create(
        row: row, col: col, is_captured: false, user: @user
      )
      piece2 = @game.pieces.create(
        row: row - 2, col: col + 2, is_captured: false, user: @user
      )
      expect(piece1.send(:valid_move?, row - 4, col + 4)).to be false
    end

>>>>>>> origin/move_obstructed
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

<<<<<<< HEAD
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
=======
    # move_to! with an obstructed horizontal move
    it "should not move the piece because of horizontal obstruction" do
      row = 4
      col = 1
      piece1 = @game.pieces.create(
        row: row, col: col, is_captured: false, user: @user
      )
      piece2 = @game.pieces.create(
        row: row, col: col + 2, is_captured: false, user: @user
      )
      piece1.move_to!(row, col + 4)
      expect(piece1.row).to eq(row)
      expect(piece1.col).to eq(col)
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
>>>>>>> origin/move_obstructed
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
