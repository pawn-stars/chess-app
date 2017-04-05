require 'rails_helper'

RSpec.describe Piece, type: :model do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:game) }
    it { should have_many(:moves) }
  end

  describe "#move_to!" do
    FROM_ROW = 3
    FROM_COL = 2
    MOVE_ROW = 6
    MOVE_COL = 1

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

    it "should update row and col attributes" do
      piece = @game.pieces.create(row: FROM_ROW, col: FROM_COL, is_black: true, user: @black)
      piece.move_to!(FROM_ROW - 1, FROM_COL)
      expect(piece.row).to eq(FROM_ROW - 1)
      expect(piece.col).to eq(FROM_COL)
    end

    it "should create a new move" do
      piece = @game.pieces.create(row: FROM_ROW, col: FROM_COL, is_black: true, user: @black)
      piece.move_to!(FROM_ROW - 1, FROM_COL)
      move = piece.moves.last
      expect(move.move_number).to eq(1)
      expect(move.from_position).to eq([FROM_ROW, FROM_COL])
      expect(move.to_position).to eq([FROM_ROW - 1, FROM_COL])
      expect(move.game_id).to eq(@game.id)
    end

    # MeO tests supporting move_to! - test private valid_move? and its called methods
    # rubocop:disable UselessAssignment
    describe "tests private valid_move?" do
      it "with a nil move" do
        piece = @game.pieces.create(row: FROM_ROW, col: FROM_COL, is_black: true, user: @black)
        expect(piece.send(:valid_move?, FROM_ROW, FROM_COL)).to be false
      end
      it "with an off-board move" do
        piece = @game.pieces.create(row: FROM_ROW, col: FROM_COL, is_black: true, user: @black)
        expect(piece.send(:valid_move?, FROM_ROW, 8)).to be false
      end
      it "with an ally-occupied destination" do
        piece1 = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        piece2 = @game.pieces.create(row: MOVE_ROW - 4, col: MOVE_COL, is_black: true, user: @black)
        expect(piece1.send(:valid_move?, MOVE_ROW - 4, MOVE_COL)).to be false
      end
      it "with an obstructed diagonal path" do
        piece1 = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        piece2 = @game.pieces.create(
          row: MOVE_ROW - 2, col: MOVE_COL + 2, is_black: false, user: @white
        )
        expect(piece1.send(:valid_move?, MOVE_ROW - 4, MOVE_COL + 4)).to be false
      end
    end

    describe "tests private move_nil?" do
      it "with a nil move" do
        piece = @game.pieces.create(row: FROM_ROW, col: FROM_COL, is_black: true, user: @black)
        expect(piece.send(:move_nil?, FROM_ROW, FROM_COL)).to be true
      end
      it "with a non-nil move" do
        piece = @game.pieces.create(row: FROM_ROW, col: FROM_COL, is_black: true, user: @black)
        expect(piece.send(:move_nil?, 5, 5)).to be false
      end
    end

    describe "tests private move_out_bounds?" do
      it "with an off-board move" do
        piece = @game.pieces.create(row: FROM_ROW, col: FROM_COL, is_black: true, user: @black)
        expect(piece.send(:move_out_of_bounds?, FROM_ROW, 8)).to be true
      end
      it "with an on-board move" do
        piece = @game.pieces.create(row: FROM_ROW, col: FROM_COL, is_black: true, user: @black)
        expect(piece.send(:move_out_of_bounds?, FROM_ROW + 1, FROM_COL + 1)).to be false
      end
    end

    describe "tests private move_destination_ally?" do
      it "with an empty destination" do
        piece = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        expect(piece.send(:move_destination_ally?, MOVE_ROW - 4, MOVE_COL)).to be false
      end
      it "with an enemy-occupied destination" do
        piece1 = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        piece2 = @game.pieces.create(
          row: MOVE_ROW - 4, col: MOVE_COL, is_black: false, user: @white
        )
        expect(piece1.send(:move_destination_ally?, MOVE_ROW - 4, MOVE_COL)).to be false
      end
      it "with an ally-occupied destination" do
        piece1 = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        piece2 = @game.pieces.create(
          row: MOVE_ROW - 4, col: MOVE_COL, is_black: true, user: @black
        )
        expect(piece1.send(:move_destination_ally?, MOVE_ROW - 4, MOVE_COL)).to be true
      end
    end

    describe "tests private move_obstructed?" do
      it "with horizontal move and no obstruction" do
        piece = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        expect(piece.send(:move_obstructed?, MOVE_ROW - 4, MOVE_COL)).to be false
      end
      it "with horizontal move and obstruction" do
        piece1 = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        piece2 = @game.pieces.create(
          row: MOVE_ROW, col: MOVE_COL + 2, is_black: true, user: @black
        )
        expect(piece1.send(:move_obstructed?, MOVE_ROW, MOVE_COL + 6)).to be true
      end

      it "with vertical move and no obstruction" do
        piece = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        expect(piece.send(:move_obstructed?, MOVE_ROW - 4, MOVE_COL)).to be false
      end
      it "with vertical move and obstruction" do
        piece1 = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        piece2 = @game.pieces.create(
          row: MOVE_ROW - 2, col: MOVE_COL, is_black: true, user: @black
        )
        expect(piece1.send(:move_obstructed?, MOVE_ROW - 4, MOVE_COL)).to be true
      end

      it "with diagonal move and no obstruction" do
        piece = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        expect(piece.send(:move_obstructed?, MOVE_ROW - 4, MOVE_COL + 4)).to be false
      end
      it "with diagonal move and obstruction" do
        piece1 = @game.pieces.create(row: MOVE_ROW, col: MOVE_COL, is_black: true, user: @black)
        piece2 = @game.pieces.create(
          row: MOVE_ROW - 2, col: MOVE_COL + 2, is_black: true, user: @black
        )
        expect(piece1.send(:move_obstructed?, MOVE_ROW - 4, MOVE_COL + 4)).to be true
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

  describe "#self_check?" do
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
      @white_king = @white.pieces.create(
        type: 'King', row: 0, col: 0, game_id: @game.id, is_black: false
      )
      @black_king = @black.pieces.create(
        type: 'King', row: 7, col: 7, game_id: @game.id, is_black: true
      )
    end

    after(:all) do
      DatabaseCleaner.clean_with(:deletion)
    end

    it "returns false if the move does not place ally king in check" do
      expect(@white_king.send(:self_check?, 1, 1)).to be_falsey
    end

    it "returns true if the move places ally king in check" do
      @black.pieces.create(type: 'Rook', row: 1, col: 1, game_id: @game.id, is_black: true)
      expect(@white_king.send(:self_check?, 0, 1)).to be_truthy
    end
  end
end
