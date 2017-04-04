class Knight < Piece
  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    (row_diff == 1 && col_diff == 2) || (row_diff == 2 && col_diff == 1)
  end
end
