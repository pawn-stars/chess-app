require 'rails_helper'

RSpec.describe Pawn, type: :model do
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

  describe '#move_legal?' do
    def forward_one(pawn)
      pawn.is_black ? -1 : 1
    end

    def forward_two(pawn)
      pawn.is_black ? -2 : 2
    end

    def back_one(pawn)
      pawn.is_black ? 1 : -1
    end

    before(:example) do
      Piece.delete_all
      white_pawn = @game.pieces.create(
        row: 1, col: 1, type: Pawn, is_black: false, user: @white
      )
      black_pawn = @game.pieces.create(
        row: 6, col: 1, type: Pawn, is_black: true, user: @black
      )
      @pawns = [white_pawn, black_pawn]
    end

    it 'allows moving forward one square' do
      @pawns.each do |pawn|
        to_row = pawn.row + forward_one(pawn)
        to_col = pawn.col

        expect(pawn.move_legal?(to_row, to_col)).to be_truthy
      end
    end

    it 'allows only the first move to be forward two squares' do
      @pawns.each do |pawn|
        to_row = pawn.row + forward_two(pawn)
        to_col = pawn.col
        expect(pawn.move_legal?(to_row, to_col)).to be_truthy

        pawn.move_to!(pawn.row + forward_one(pawn), pawn.col)
        to_row = pawn.row + forward_two(pawn)
        expect(pawn.move_legal?(to_row, to_col)).to be_falsey
      end
    end

    it 'allows capture moves' do
      [1, -1].each do |col_offset|
        @pawns.each do |pawn|
          if pawn.is_black
            enemy = @game.pieces.create(row: 5, col: 1 + col_offset, is_black: false, user: @white)
          else
            enemy = @game.pieces.create(row: 2, col: 1 + col_offset, is_black: true, user: @black)
          end
          to_row = pawn.row + forward_one(pawn)
          to_col = pawn.col + col_offset
          expect(pawn.move_legal?(to_row, to_col)).to be_truthy

          to_col = pawn.col - col_offset
          expect(pawn.move_legal?(to_row, to_col)).to be_falsey

          enemy.destroy
        end
      end
    end

    it 'allows en passant' do
      [1, -1].each do |col_offset|
        @pawns.each do |pawn|
          enemy =
            if pawn.is_black
              @game.pieces.create(
                row: 1, col: 1 + col_offset, type: Pawn, is_black: false, user: @white
              )
            else
              @game.pieces.create(
                row: 6, col: 1 + col_offset, type: Pawn, is_black: true, user: @black
              )
            end

          enemy.move_to!(enemy.row + forward_two(enemy), enemy.col)
          pawn.update(row: enemy.row)
          to_row = pawn.row + forward_one(pawn)
          to_col = pawn.col + col_offset
          expect(pawn.move_legal?(to_row, to_col)).to be_truthy

          to_col = pawn.col - col_offset
          expect(pawn.move_legal?(to_row, to_col)).to be_falsey

          enemy.destroy
        end
      end
    end
  end
end
