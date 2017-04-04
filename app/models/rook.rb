class Rook < Piece
  def move_legal?(to_row, to_col)
    return true if col == to_col || row == to_row
    false
  end
end
