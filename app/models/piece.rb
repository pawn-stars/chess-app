class Piece < ApplicationRecord
  belongs_to :game
  has_many :pieces
end
