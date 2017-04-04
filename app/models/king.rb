class King < Piece

  def valid_move?(to_row, to_col)
    logger.debug "valid_move for #{type}"
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
  end   # end move_legal?

  private

  def legal_castle_move(to_row, to_col)
    logger.debug "CASTLE"
    return false unless moves.empty?
    return false unless row == to_row   # on same row
    return false until (col - to_col).abs == 2   # moved 2 spaces

    # verify rook in correct location and has not moved
    logger.debug("Getting the rook")
    @rook = nil
    side = ''
    new_king_col = new_rook_col = -1
    if col < to_col   # king side castle
      side = 'king'
      new_king_col = 6
      new_rook_col = 5
      @rook = rook_at(row,7)
    else
      side = 'queen'
      new_king_col = 2
      new_rook_col = 3
      @rook = rook_at(row,0)
    end
    return false unless @rook

    return false if move_obstructed?(@rook.row,@rook.col)
    logger.debug "continue with the castle. clear path"

    update_attributes(row: to_row, col: new_king_col)
    create_move!(to_row, new_king_col)

    @rook.update_attributes(row: to_row, col: new_rook_col)
    create_move!(to_row, new_rook_col)

    logger.debug "king and rook should have castled"
    true

  end

  def rook_at(check_row, check_col)
    rook = game.piece_at(check_row, check_col)
    rook if rook && rook.moves.empty?
  end

end   # Class King
