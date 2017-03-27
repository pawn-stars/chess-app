# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength

class Game < ApplicationRecord
  has_many :participations
  has_many :pieces
  has_many :moves

  scope :available,
        lambda {
          where('(white_player_id IS NULL AND black_player_id IS NOT NULL)
          OR
          (white_player_id IS NOT NULL AND black_player_id IS NULL)')
        }

  class Board
    attr_reader :grid

    def initialize(pieces)
      @pieces = pieces.are_not_captured
      @grid = Array.new(8) { Array.new(8) }
      fill_grid
    end

    private

    attr_reader :pieces

    def fill_grid
      pieces.each do |piece|
        if grid[piece.row][piece.col]
          raise "uncaptured pieces occupy same square"
        end
        grid[piece.row][piece.col] = piece
      end
    end
  end

  # This locates an individual piece for use in the capture method
  def piece_at(row, col)
    pieces.where(row: row, col: col).first
  end

  def populate_board
    # White pieces
    Rook.create(game_id: id, user_id: white_player_id, row: 0, col: 0, is_black: false)
    Knight.create(game_id: id, user_: white_player_id, row: 0, col: 1, is_black: false)
    Bishop.create(game_id: id, user_id: white_player_id, row: 0, col: 2, is_black: false)
    Queen.create(game_id: id, user_id: white_player_id, row: 0, col: 3, is_black: false)
    King.create(game_id: id, user_id: white_player_id, row: 0, col: 4, is_black: false)
    Bishop.create(game_id: id, user_id: white_player_id, row: 0, col: 5, is_black: false)
    Knight.create(game_id: id, user_id: white_player_id, row: 0, col: 6, is_black: false)
    Rook.create(game_id: id, user_id: white_player_id, row: 0, col: 7, is_black: false)
    (0..7).each do |i|
      Pawn.create(game_id: id,
                  user_id: white_player_id,
                  row: 1,
                  col: i,
                  is_black: false)
    end

    # Black pieces
    (0..7).each do |i|
      Pawn.create(game_id: id,
                  user_id: black_player_id,
                  row: 6,
                  col: i,
                  is_black: true)
    end
    Rook.create(game_id: id, user_id: black_player_id, row: 7, col: 0, is_black: true)
    Knight.create(game_id: id, user_id: black_player_id, row: 7, col: 1, is_black: true)
    Bishop.create(game_id: id, user_id: black_player_id, row: 7, col: 2, is_black: true)
    Queen.create(game_id: id, user_id: black_player_id, row: 7, col: 3, is_black: true)
    King.create(game_id: id, user_id: black_player_id, row: 7, col: 4, is_black: true)
    Bishop.create(game_id: id, user_id: black_player_id, row: 7, col: 5, is_black: true)
    Knight.create(game_id: id, user_id: black_player_id, row: 7, col: 6, is_black: true)
    Rook.create(game_id: id, user_id: black_player_id, row: 7, col: 7, is_black: true)
  end
end
