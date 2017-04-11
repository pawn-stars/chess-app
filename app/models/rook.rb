class Rook < Piece
  def move_legal?(to_row, to_col)
    col == to_col || row == to_row
  end

  def can_castle_to?(king_col)
    # Jacob and Jim
    #   I have spent the majority of my time with the task on move_obstructed? for a castle
    #   Jim had suggested a path_is_clear method
    #      BUT why do that when PIECE::move_obstructed is perfect
    #   Jacob recommended overriding super in King to always return true
    #   This is the only place to call the parent move_obstructed and keep my code DRY

    return false if move_obstructed?(row, king_col)
    new_rook_col = col.zero? ? 3 : 5
    update_piece(row, new_rook_col, 'castle')
    true
  end
end
