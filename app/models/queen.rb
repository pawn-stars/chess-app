class Queen < Piece
  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    row_diff <= 1 && col_diff <= 1
  end

  def valid_move?(row, col)
    return false unless super(row, col)
    return false if path_blocked?(row, col)
    row_diff = row_diff(row)
    col_diff = col_diff(col)
    return true if row_diff == col_diff
    if row_diff > 0 && col_diff.zero?
      return true
    end
    if row_diff.zero? && col_diff > 0
      return true
    end
  end

  def display_piece
    black? ? "&#9819;" : "&#9813;"
  end
end
