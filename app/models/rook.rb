class Rook < Piece

  def display_piece
    if black?
      return "&#9820;"
    else
      return "&#9814;"
    end
  end

end
