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

    it "should raise an error if the arguments are out of bounds" do
      piece = @game.pieces.create(
        row: 0, col: 0, is_captured: false, user: @user
      )

      expect { piece.move_to!(8, 0) }.to raise_error(RuntimeError)
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
