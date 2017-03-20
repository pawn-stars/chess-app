class Pawn < Piece

  def display_piece
    if black?
      return "&#9823;"
    else
      return "&#9817;"
    end
  end

end
