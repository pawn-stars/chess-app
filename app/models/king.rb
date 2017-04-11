class King < Piece
  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    return true if row_diff <= 1 && col_diff <= 1

    # King castling?
    return false unless row_diff.zero? && col_diff == 2
    move_legal_castle?(to_col)
  end

  # Jacob requested change
  def move_obstructed?(_to_row, _to_col)
    false
  end

  def castling?(to_row, to_col)
    row == to_row && (col - to_col).abs == 2
  end

  private

  # Jacob - keeping name as below instead of can_castle_to
  #         follows naming conventions from piece.rb with move_<something>
  def move_legal_castle?(to_col)
    # Jacob - moved here to fix rubcocop ABC error on move_legal?
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
