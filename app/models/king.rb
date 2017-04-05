# rubocop:disable Metrics/AbcSize
class King < Piece
  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    row_diff <= 1 && col_diff <= 1
  end

  def in_check?
    !get_attackers.empty?
  end

  # call this method on the enemy king after the end of a turn
  def checkmate?
    if in_check? && move_space.none? { |move| valid_move?(move[0], move[1]) }
      

    end
  end

  def stalemate?
    if !in_check? && move_space.none? { |move| valid_move?(move[0], move[1]) }
    end
  end

  def move_space
    [[row + 1, col + 1], [row + 1, col], [row + 1, col - 1],
     [row,     col + 1],                 [row,     col - 1],
     [row - 1, col + 1], [row - 1, col], [row - 1, col - 1]]
  end

  def get_attackers
    enemies = game.pieces.where.not(is_black: is_black)
    attackers = []
    enemies.where.not(type: 'King').each do |enemy|
      attackers << enemy if enemy.valid_move?(row, col)
    end
    enemy_king = enemies.where(type: 'King').first
    attackers << enemy_king if enemy_king.move_space.include?([row, col])
    attackers
  end
end
