# rubocop:disable Metrics/AbcSize
class King < Piece
  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    row_diff <= 1 && col_diff <= 1
  end

  def in_check?
    enemies = game.pieces.where.not(is_black: is_black)
    enemies.where.not(type: 'King').any? { |enemy| enemy.valid_move?(row, col) } ||
      enemies.where(type: 'King').first.move_space.include?([row, col])
  end

  # call this method on the enemy king after the end of a turn
  def checkmate?
    in_check? && move_space.none? { |move| valid_move?(move[0], move[1]) }
  end

  def stalemate?
    !in_check? && move_space.none? { |move| valid_move?(move[0], move[1]) }
  end

  def move_space
    [[row + 1, col + 1], [row + 1, col], [row + 1, col - 1],
     [row,     col + 1],                 [row,     col - 1],
     [row - 1, col + 1], [row - 1, col], [row - 1, col - 1]]
  end
end
