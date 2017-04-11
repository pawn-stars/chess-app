class Rook < Piece
  def move_legal?(to_row, to_col)
    col == to_col || row == to_row
  end

  def can_castle_to?(king_col)
    return false if move_obstructed?(row, king_col)
    new_rook_col = col.zero? ? 3 : 5
    update_piece(row, new_rook_col, 'castle')
    true
  end
end
