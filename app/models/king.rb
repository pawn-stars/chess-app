class King < Piece
  def move_legal?(to_row, to_col)
    Rails.logger.debug "KING move_legal"
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    row_diff <= 1 && col_diff <= 1
  end # method move_legal?
end
