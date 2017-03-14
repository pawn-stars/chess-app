class Piece < ApplicationRecord
  belongs_to :game
  has_many :moves

  def self.types
      %w(Pawn Rook Knight Bishop Queen King)
  end
end