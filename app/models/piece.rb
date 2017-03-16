class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :moves
  
  scope :are_captured, -> { where(is_captured: true) }
  scope :are_not_captured, -> { where(is_captured: false) }
  
  def move_to!(row, col)
    raise "Out of bounds" if (row < 0 || row > 7 || col < 0 || col > 7)
    self.update(row: row, col:col)
  end
end
