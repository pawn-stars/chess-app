class Rook < Piece
  def valid_move?(to_row, to_col)
    return true if col == to_col || row == to_row
    false
  end
end
