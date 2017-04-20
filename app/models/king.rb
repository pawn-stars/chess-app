# rubocop:disable Metrics/AbcSize
# rubocop:disable Style/SymbolProc
class King < Piece
  # ensure King didn't move itself into check
  def finalize_move!(to_row, to_col)
    return false if get_attackers(to_row, to_col).present?
    move_to!(to_row, to_col)
  end

  def move_legal?(to_row, to_col)
    row_diff = (row - to_row).abs
    col_diff = (col - to_col).abs
    return true if row_diff <= 1 && col_diff <= 1

    # King castling?
    return false unless row_diff.zero? && col_diff == 2
    move_legal_castle?(to_col)
  end

  def move_obstructed?(_to_row, _to_col)
    false
  end

  def castling?(to_row, to_col)
    return "normal" unless row == to_row && (col - to_col).abs == 2
    col < to_col ? "castle. kingside" : "castle. queenside"
  end

  def move_legal_castle?(to_col)
    return false unless moves.empty?

    # get the castling rook
    rook = get_castling_rook(to_col)
    return false unless rook

    # check intermediate square for attackers
    return false if get_attackers(row, col + (to_col <=> col)).present?

    # good castle - update rook column in DB
    rook.update_rook_for_castle
    true
  end

  def get_castling_rook(to_col)
    rook_col = col < to_col ? 7 : 0
    rook = game.piece_at(row, rook_col)
    return false unless rook && rook.moves.empty?
    return rook if rook.king_rook_path_clear?(col)
    false
  end

  def in_check?
    get_attackers(row, col).present?
  end

  # call this method on the enemy king after the end of a turn
  def checkmate?
    return false unless in_check? && valid_moves.empty?
    attackers = get_attackers(row, col)
    return true if attackers.length > 1
    return false if attacker_is_vulnerable?(attackers.first)
    return false if attacker_is_blockable?(attackers.first)
    true
  end

  def stalemate?
    !in_check? && valid_moves.empty? && allies.all? { |ally| ally.cant_move? }
  end

  def move_space
    [[row + 1, col + 1], [row + 1, col], [row + 1, col - 1],
     [row,     col + 1],                 [row,     col - 1],
     [row - 1, col + 1], [row - 1, col], [row - 1, col - 1]]
  end

  def valid_moves
    move_space.select { |move| valid_move?(move[0], move[1]) }.select do |move|
      get_attackers(move[0], move[1]).empty?
    end
  end

  def get_attackers(check_row, check_col)
    game.pieces.where.not(is_black: is_black).select do |enemy|
      enemy.valid_move?(check_row, check_col)
    end
  end

  def attacker_is_vulnerable?(attacker)
    allies.any? { |ally| ally.valid_move?(attacker.row, attacker.col) }
  end

  def attacker_is_blockable?(attacker)
    return false unless %w(Rook Bishop Queen).include?(attacker.type)
    attacker.path_to_king.any? do |square|
      allies.to_a.any? { |ally| ally.valid_move?(square[0], square[1]) }
    end
  end

  def allies
    game.pieces.where(is_black: is_black).where.not(type: 'King')
  end
end
