class Game < ApplicationRecord
  has_many :participations
  has_many :pieces

  scope :available,
        lambda {
          where('(white_player_id IS NULL AND black_player_id IS NOT NULL)
          OR
          (white_player_id IS NOT NULL AND black_player_id IS NULL)')
        }

  class Board
    attr_reader :grid
    
    def initialize(pieces)
      @pieces = pieces
      @grid = Array.new(8) { Array.new(8) }
      fill_grid
    end
    
    private
    
    def pieces
      @pieces
    end
    
    def fill_grid
      pieces.each do |piece|
        next if piece.is_captured
        if grid[piece.row][piece.col]
          raise "uncaptured pieces occupy same square"
        end
        grid[piece.row][piece.col] = piece
      end
    end
  end
end
