class Queen < Piece
  def path_to_king
    king = game.pieces.where.not(is_black: is_black).where(type: 'King').first
    return nil unless king.row == row || king.col == col ||
                      (king.row - row).abs == (king.col - col).abs
    get_path(king.row, king.col)
  end
end
