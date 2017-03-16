class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :moves

  def self.types
      %w(Pawn Rook Knight Bishop Queen King)
  end
  
  scope :are_captured, -> { where(is_captured: true) }
  scope :are_not_captured, -> { where(is_captured: false) }
end
