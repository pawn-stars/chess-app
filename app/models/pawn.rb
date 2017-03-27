class Pawn < Piece
  def move_legal?(to_row, to_col)
    return true if single_advance?(to_row, to_col)
    return true if double_advance?(to_row, to_col)
    return true if capture_move?(to_row, to_col)
    return true if en_passant?(to_row, to_col) # need to send signal to capture logic
    return false
  end

  def promotion
  end

  private

  def single_advance?(to_row, to_col)
    if is_black?
      to_row == row - 1 && to_col == col
    else
      to_row == row + 1 && to_col == col
    end
  end

  def double_advance?(to_row, to_col)
    if is_black?
      to_row == 4 && to_col == col && moves.empty?
    else
      to_row == 3 && to_col == col && moves.empty?
    end
  end

  def capture_move?(to_row, to_col)
    if is_black?
      if to_row == row - 1 && ( to_col == col + 1 || to_col == col - 1)
        enemy_occupied?(to_row, to_col)
      end
    else
      if to_row == row + 1 && ( to_col == col + 1 || to_col == col - 1)
        enemy_occupied?(to_row, to_col)
      end
    end
  end

  def en_passant?(to_row, to_col)
    if is_black?
      if moves.length == 1 && row == 4
        if to_row == row - 1 && ( to_col == col + 1 || to_col == col - 1)
          enemy_occupied?(to_row + 1, to_col)
        end
      end
    else
      if moves.length == 1 && row == 3
        if to_row == row + 1 && ( to_col == col + 1 || to_col == col - 1)
          enemy_occupied?(to_row - 1, to_col)
        end
      end
    end
  end

  def enemy_occupied?(row, col)
    piece = Game::Board.new(game.pieces)[row][col]
    piece && piece.user_id != user_id
  end
end
