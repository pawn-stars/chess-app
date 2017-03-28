class Bishop < Piece
  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    row_diff == col_diff
  end

  def display_piece
    black? ? "&#9821;" : "&#9815;"
  end
end
