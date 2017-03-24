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
    from_row = 3
    from_col = 2

    it "should not move the piece: nil move" do
      piece = @game.pieces.create(row: from_row, col: from_col, is_captured: false, user: @user)
      piece.move_to!(from_row,from_col)
      expect(piece.row).to eq(from_row)
      expect(piece.col).to eq(from_col)
    end

    it "should not move the piece: out of bounds move" do
      piece = @game.pieces.create(row: from_row, col: from_col, is_captured: false, user: @user)
      piece.move_to!(8,8)
      expect(piece.row).to eq(from_row)
      expect(piece.col).to eq(from_col)
    end

    # remove test after all piece subclass tests complete
    it "should move the piece: horizonal move" do
      to_col = 7
      piece = @game.pieces.create(row: from_row, col: from_col, is_captured: false, user: @user)
      piece.move_to!(from_row,to_col)
      expect(piece.row).to eq(from_row)
      expect(piece.col).to eq(to_col)
    end
    # remove test after all piece subclass tests complete
    it "should move the piece: vertical move" do
      to_row = 7
      piece = @game.pieces.create(row: from_row, col: from_col, is_captured: false, user: @user)
      piece.move_to!(to_row,from_col)
      expect(piece.row).to eq(to_row)
      expect(piece.col).to eq(from_col)
    end
    # remove test after all piece subclass tests complete
    it "should move the piece: diagonal move" do
      to_row = 6
      to_col = 5
      piece = @game.pieces.create(row: from_row, col: from_col, is_captured: false, user: @user)
      piece.move_to!(to_row,to_col)
      expect(piece.row).to eq(to_row)
      expect(piece.col).to eq(to_col)
    end
  end
end



#RSpec.describe Bishop, type: :model do
#  describe '#move_legal?' do
#    let(:bishop) { Bishop.create(row: 3, col: 3) }

#    it "allows legal moves" do
#      expect(bishop.move_legal?(6, 6)).to be true
#    end

#    it "does not allow not legal moves" do
#      expect(bishop.move_legal?(4, 5)).to be false
#    end
#  end
# end
