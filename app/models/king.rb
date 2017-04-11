class King < Piece
  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    return true if row_diff <= 1 && col_diff <= 1

    # King castling?
    return false unless row_diff.zero? && col_diff == 2
    move_legal_castle?(to_col)
  end

  def move_obstructed?(_to_row, _to_col)
    false
  end

  def castling?(to_row, to_col)
    row == to_row && (col - to_col).abs == 2
  end

  private

  def move_legal_castle?(to_col)
    return false unless moves.empty?

    rook = get_castling_rook(to_col)
    return unless rook
    return false unless rook.can_castle_to?(col)
    true
  end

  def get_castling_rook(to_col)
    rook_col = col < to_col ? 7 : 0
    rook = game.piece_at(row, rook_col)
    rook if rook && rook.moves.empty?
  end
end
