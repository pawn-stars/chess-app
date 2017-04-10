class Rook < Piece
  def move_legal?(to_row, to_col)
    return true if col == to_col || row == to_row
    false
  end

  def path_to_king
    king = game.pieces.where.not(is_black: is_black).where(type: 'King').first
    return nil unless king.row == row || king.col == col
    get_path(king.row, king.col)
  end
end
