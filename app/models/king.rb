class King < Piece
  def valid_move?(to_row, to_col)
    logger.debug "*** KING: #{id} #{type} valid_move?"
    return false if move_nil?(to_row, to_col)
    return false if move_out_of_bounds?(to_row, to_col)
    return false if move_destination_ally?(to_row, to_col)
    return false unless move_legal?(to_row, to_col)
    true
  end

  def move_legal?(to_row, to_col)
    logger.debug "move_legal for #{type}"
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    return true if row_diff <= 1 && col_diff <= 1

    legal_castle_move(to_row, to_col)
  end

  private

  def legal_castle_move(to_row, to_col)
    return false unless legal_king_move?(to_row, to_col)
    legal_rook_move?(to_col)
  end

  def legal_king_move?(to_row, to_col)
    return false unless moves.empty?
    return false unless row == to_row
    return false unless (col - to_col).abs == 2
    true
  end

  def legal_rook_move?(to_col)
    rook = get_rook?(to_col)
    return false unless rook
    return false if move_obstructed?(row, rook.col)
    new_rook_col = rook.col.zero? ? 3 : 5
    rook.update_piece(row, new_rook_col, 'castled')
    true
  end

  def get_rook?(to_col)
    col < to_col ? rook_at(row, 7) : rook_at(row, 0)
  end

  def rook_at(check_row, check_col)
    rook = game.piece_at(check_row, check_col)
    rook if rook && rook.moves.empty?
  end
end
