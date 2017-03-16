class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :moves
  
  scope :are_captured, -> { where(is_captured: true) }
  scope :are_not_captured, -> { where(is_captured: false) }
end
