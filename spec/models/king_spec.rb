require 'rails_helper'

RSpec.describe King, type: :model do
  describe '#move_legal?' do
    from_row = 0
    from_col = 4

    let(:king) { King.create(row: from_row, col: from_col) }

    it "allows King legal move: horizontal" do
      expect(king.move_legal?(from_row, from_col + 1)).to be true
    end

    it "allows legal move: vertical" do
      king.update_attributes(row: from_row, col: from_col)
      expect(king.move_legal?(from_row + 1, from_col)).to be true
    end

    it "allows legal move: diagonal" do
      king.update_attributes(row: from_row, col: from_col)
      expect(king.move_legal?(from_row + 1, from_col + 1)).to be true
    end

    it "does not allow not legal move" do
      king.update_attributes(row: from_row, col: from_col)
      expect(king.move_legal?(from_row + 2, from_col + 3)).to be false
    end
  end

  context "checks and mates" do
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

    describe "#in_check?" do
      before(:example) do
        @white_king = @white.pieces.create(
          type: 'King', row: 0, col: 0, game_id: @game.id, is_black: false
        )
        @black_king = @black.pieces.create(
          type: 'King', row: 7, col: 7, game_id: @game.id, is_black: true
        )
      end

      it "returns false if not in check" do
        expect(@white_king.in_check?).to be_falsey
      end

      it "returns true if checked by enemy king" do
        @black_king.update(row: 1, col: 1)
        expect(@white_king.in_check?).to be_truthy
      end

      it "returns true if checked by a non-king enemy" do
        @black.pieces.create(
          type: 'Rook', row: 2, col: 0, game_id: @game.id, is_black: true
        )
        expect(@white_king.in_check?).to be_truthy
      end
    end

    describe "#checkmate?" do
      before(:example) do
        @white_king = @white.pieces.create(
          type: 'King', row: 0, col: 0, game_id: @game.id, is_black: false
        )
        @black_king = @black.pieces.create(
          type: 'King', row: 7, col: 7, game_id: @game.id, is_black: true
        )
      end

      it "returns false if not checkmated" do
        expect(@white_king.checkmate?).to be_falsey
      end

      it "returns true if checkmated" do
        @black.pieces.create(
          type: 'Rook', row: 2, col: 0, game_id: @game.id, is_black: true
        )
        @black.pieces.create(
          type: 'Rook', row: 2, col: 1, game_id: @game.id, is_black: true
        )
        expect(@white_king.checkmate?).to be_truthy
      end

      it "returns false if an attacker can be captured" do
        @black.pieces.create(
          type: 'Rook', row: 2, col: 0, game_id: @game.id, is_black: true
        )
        @black.pieces.create(
          type: 'Rook', row: 2, col: 1, game_id: @game.id, is_black: true
        )
        a = @white.pieces.create(
          type: 'Rook', row: 3, col: 0, game_id: @game.id, is_black: false
        )
        expect(@white_king.checkmate?).to be_falsey
      end
    end

    describe "#stalemate?" do
      before(:example) do
        @white_king = @white.pieces.create(
          type: 'King', row: 0, col: 0, game_id: @game.id, is_black: false
        )
        @black_king = @black.pieces.create(
          type: 'King', row: 7, col: 7, game_id: @game.id, is_black: true
        )
      end

      it "returns false if checkmated" do
        @black.pieces.create(type: 'Rook', row: 2, col: 0, game_id: @game.id, is_black: true)
        @black.pieces.create(type: 'Rook', row: 2, col: 1, game_id: @game.id, is_black: true)
        expect(@white_king.stalemate?).to be_falsey
      end

      it "returns true if stalemated" do
        @black.pieces.create(type: 'Rook', row: 2, col: 1, game_id: @game.id, is_black: true)
        @black.pieces.create(type: 'Rook', row: 1, col: 2, game_id: @game.id, is_black: true)
        expect(@white_king.stalemate?).to be_truthy
      end
    end
  end
end
