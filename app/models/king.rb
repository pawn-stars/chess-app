class King < Piece
  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    row_diff <= 1 && col_diff <= 1
  end

  def in_check?
    enemies = game.pieces.where.not(is_black: is_black).where.not(type: King)
    enemies.where.not(type: King).each do |enemy|
      return true if enemy.valid_move?(row, col)
    end
    return true if enemies.where(type: King).move_space.includes([row, col])
    false
  end

  def checkmate?
    in_check? && move_space.none? { |move| move.valid_move?(move[0], move[1]) }
  end

  def stalemate?
    !in_check? && move_space.none? { |move| move.valid_move?(move[0], move[1]) }
  end

  def move_space
    [[row + 1, col + 1], [row + 1, col], [row + 1, col - 1],
     [row,     col + 1],                 [row,     col - 1],
     [row - 1, col + 1], [row - 1, col], [row - 1, col - 1]]
  end
end
