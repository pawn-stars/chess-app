require 'rails_helper'

RSpec.describe Pawn, type: :model do
  before(:all) do
    User.delete_all
    Game.delete_all

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

  describe '#move_legal?' do
    context 'pawn is white' do
      before(:example) do
        Piece.delete_all
        @pawn = @game.pieces.create(
          row: 1, col: 1, type: Pawn, is_black: false, user: @white
        )
      end

      let(:forward_one) { 1 }
      let(:forward_two) { 2 }

      it 'allows moving forward one square' do
        to_row = @pawn.row + forward_one
        to_col = @pawn.col
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy
      end

      it 'allows only the first move to be forward two squares' do
        to_row = @pawn.row + forward_two
        to_col = @pawn.col
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy

        @pawn.move_to!(@pawn.row + forward_one, @pawn.col)
        to_row = @pawn.row + forward_two
        expect(@pawn.move_legal?(to_row, to_col)).to be_falsey
      end

      it 'allows right-side capture moves' do
        @game.pieces.create(row: 2, col: 2, is_black: true, user: @black)

        to_row = @pawn.row + forward_one
        to_col = @pawn.col + 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy

        to_col = @pawn.col - 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_falsey
      end

      it 'allows left-side capture moves' do
        @game.pieces.create(row: 2, col: 0, is_black: true, user: @black)

        to_row = @pawn.row + forward_one
        to_col = @pawn.col - 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy

        to_col = @pawn.col + 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_falsey
      end

      it 'allows right-side en passant' do
        @pawn.move_to!(3, @pawn.col)
        @game.pieces.create(row: 3, col: @pawn.col + 1, is_black: true, user: @black)

        to_row = @pawn.row + forward_one
        to_col = @pawn.col + 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy

        to_col = @pawn.col - 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_falsey
      end

      it 'allows left-side en passant' do
        @pawn.move_to!(3, @pawn.col)
        @game.pieces.create(row: 3, col: @pawn.col - 1, is_black: true, user: @black)

        to_row = @pawn.row + forward_one
        to_col = @pawn.col - 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy

        to_col = @pawn.col + 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_falsey
      end
    end

    ############################################################################
    ################################ Color Divider #############################
    ############################################################################

    context 'pawn is black' do
      before(:example) do
        Piece.delete_all
        @pawn = @game.pieces.create(
          row: 6, col: 1, type: Pawn, is_black: true, user: @black
        )
      end

      let(:forward_one) { -1 }
      let(:forward_two) { -2 }

      it 'allows moving forward one square' do
        to_row = @pawn.row + forward_one
        to_col = @pawn.col
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy
      end

      it 'allows only the first move to be forward two squares' do
        to_row = @pawn.row + forward_two
        to_col = @pawn.col
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy

        @pawn.move_to!(@pawn.row + forward_one, @pawn.col)
        to_row = @pawn.row + forward_two
        expect(@pawn.move_legal?(to_row, to_col)).to be_falsey
      end

      it 'allows right-side capture moves' do
        @game.pieces.create(row: 5, col: 2, is_black: false, user: @white)

        to_row = @pawn.row + forward_one
        to_col = @pawn.col + 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy

        to_col = @pawn.col - 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_falsey
      end

      it 'allows left-side capture moves' do
        @game.pieces.create(row: 5, col: 0, is_black: false, user: @white)

        to_row = @pawn.row + forward_one
        to_col = @pawn.col - 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy

        to_col = @pawn.col + 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_falsey
      end

      it 'allows right-side en passant' do
        @pawn.move_to!(4, @pawn.col)
        @game.pieces.create(row: 4, col: @pawn.col + 1, is_black: false, user: @white)

        to_row = @pawn.row + forward_one
        to_col = @pawn.col + 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy

        to_col = @pawn.col - 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_falsey
      end

      it 'allows left-side en passant' do
        @pawn.move_to!(4, @pawn.col)
        @game.pieces.create(row: 4, col: @pawn.col - 1, is_black: false, user: @white)

        to_row = @pawn.row + forward_one
        to_col = @pawn.col - 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_truthy

        to_col = @pawn.col + 1
        expect(@pawn.move_legal?(to_row, to_col)).to be_falsey
      end
    end
  end
end
