class Rook < Piece
  def valid_move?(to_row, to_col)
    # Returns to false if pathis obstructed, as Rook cannot jump its own pieces
    # return false if piece.path_obstructed?
    # Vertical move col stays the same # Horizontal move row stays the same
    return true if (col - to_col).zero? || (row - to_row).zero?
  end
end
