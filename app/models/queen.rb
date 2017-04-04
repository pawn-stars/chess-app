class Queen < Piece
  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    row_diff == col_diff || row_diff.zero? || col_diff.zero?
  end
end
