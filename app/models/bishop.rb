class Bishop < Piece
  def move_legal?(to_row, to_col)
    row_diff = (self.row - to_row).abs
    col_diff = (self.col - to_col).abs
    row_diff == col_diff
  end
end
