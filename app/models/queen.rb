class Queen < Piece
  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    row_diff == col_diff || row_diff.zero? || col_diff.zero?
  end

  def path_to_king
    king = game.pieces.where.not(is_black: is_black).where(type: 'King').first
    return nil unless valid_move?(king.row, king.col)
    get_path(king.row, king.col)
  end
end
