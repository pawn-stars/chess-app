class Queen < Piece
  def path_to_king
    king = game.pieces.where.not(is_black: is_black).where(type: 'King').first
    return nil unless valid_move?(king.row, king.col)
    get_path(king.row, king.col)
  end
end
