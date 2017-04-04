class Knight < Piece
  def move_legal?(to_row, to_col)
    return false if row == to_row
    return false if col == to_col
    (row - to_row).abs + (col - to_col).abs == 3
  end

  def move_obstructed?(_to_row, _to_col)
    false
  end
end
