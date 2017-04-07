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
  end   # end move_legal?

  private

  def legal_castle_move(to_row, to_col)
    logger.debug "CASTLE"
    return false unless moves.empty?
    return false unless row == to_row   # on same row
    return false unless (col - to_col).abs == 2   # moved 2 spaces

    # verify rook in correct location and has not moved
    logger.debug("Getting the rook")
    @rook = nil

    # get the correct rook for castle side, make sure first move,
    # path from king to rook not obstructed
    new_rook_col = -1
    if col < to_col
      logger.debug "get right rook"
       @rook = rook_at(row,7)
       new_rook_col = 5
    else
      logger.debug "get left rook"
      @rook = rook_at(row,0)
      new_rook_col = 3
    end
    return false unless @rook
    return false if move_obstructed?(@rook.row,@rook.col)

    # update the rook's row,col. parent class will update the king's row,col
    logger.debug "continue with the castle. clear path. move rook #{@rook.id} in column #{@rook.col}"
    @rook.update_piece(row, new_rook_col, 'castled')
    # create_move!(row, new_rook_col)
    logger.debug "king and rook should have castled"
    true
  end

  def rook_at(check_row, check_col)
    rook = game.piece_at(check_row, check_col)
    logger.debug "rook at #{check_col}"
    rook if rook && rook.moves.empty?
  end
end   # CLASS
