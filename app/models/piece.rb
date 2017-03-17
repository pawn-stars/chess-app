class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :moves

  scope :are_captured, -> { where(is_captured: true) }
  scope :are_not_captured, -> { where(is_captured: false) }

  def self.types
    %w(Pawn Rook Knight Bishop Queen King)
  end

  def move_to!(row, col)
    raise "Out of bounds" if row < 0 || row > 7 || col < 0 || col > 7
    update(row: row, col: col)
  end
end
