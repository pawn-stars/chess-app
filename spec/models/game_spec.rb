require 'rails_helper'

RSpec.describe Game, type: :model do
  context "associations" do
    it { should have_many(:participations) }
    it { should have_many(:pieces) }
  end

  describe "#available" do
    it "should include games with one player" do
      Game.create(white_player_id: 1)
      Game.create(black_player_id: 1)
      expect(Game.available.count).to eq(2)
    end

    it "should exclude games with two players" do
      Game.create(white_player_id: 1, black_player_id: 2)
      expect(Game.available.count).to eq(0)
    end

    it "should exclude games with zero players" do
      Game.create
      expect(Game.available.count).to eq(0)
    end
  end

  context "Board" do
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

    describe "#grid" do
      it "returns an 8x8 array that may have Piece instances as elements" do
        piece1 = @game.pieces.create(row: 0, col: 0, user: @user)
        piece2 = @game.pieces.create(row: 7, col: 7, user: @user)
        board = Game::Board.new(@game.pieces)

        expect(board.grid[0][0].id).to eq(piece1.id)
        expect(board.grid[7][7].id).to eq(piece2.id)
      end
    end

    describe "#fill_grid" do
      it "raises an error if uncaptured pieces occupy the same square" do
        @game.pieces.create(row: 0, col: 0, user: @user)
        @game.pieces.create(row: 0, col: 0, user: @user)

        expect { Game::Board.new(@game.pieces) }.to raise_error(RuntimeError)
      end
    end
  end

 describe "#populate_board" do
    it "should populate board only if both black and white player ids are present" do
      game = Game.create(white_player_id: 0, black_player_id: 1)
      game.populate_board
      expect(game.pieces.count).to eq(32)
    end
  end
end
