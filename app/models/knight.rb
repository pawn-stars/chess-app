class Knight < Piece
  def move_legal?(to_row, to_col)
    logger.debug "KNIGHT move_legal?"
    return false if row == to_row
    return false if col == to_col
    (row - to_row).abs + (col - to_col).abs == 3
  end
end
