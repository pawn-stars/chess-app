class Pawn < Piece
  def move_legal?(to_row, to_col)
    return true if single_advance?(to_row, to_col)
    return true if double_advance?(to_row, to_col)
    return true if capture_move?(to_row, to_col)
    return true if en_passant?(to_row, to_col) # need to send signal to capture logic for en passant
    false
  end

  def promotion
  end

  private

  def single_advance?(to_row, to_col)
    valid_to_row = is_black ? row - 1 : row + 1
    to_row == valid_to_row && to_col == col
  end

  def double_advance?(to_row, to_col)
    valid_to_row = is_black ? 4 : 3
    to_row == valid_to_row && to_col == col && moves.empty?
  end

  def capture_move?(to_row, to_col)
    valid_to_row = is_black ? row - 1 : row + 1
    to_row == valid_to_row && (to_col - col).abs == 1 && enemy_occupied?(to_row, to_col)
  end

  def en_passant?(to_row, to_col)
    valid_to_row = is_black ? row - 1 : row + 1
    valid_row = is_black ? 4 : 3
    return false unless moves.length == 1 && row == valid_row
    return false unless to_row == valid_to_row && (to_col - col).abs == 1
    enemy_occupied?(row, to_col)
  end

  def enemy_occupied?(check_row, check_col)
    piece = Game::Board.new(game.pieces).grid[check_row][check_col]
    p piece
    piece && !piece.captured? && piece.user_id != user_id
  end
end
