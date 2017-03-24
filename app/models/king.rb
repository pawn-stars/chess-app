class King < Piece

  def display_piece
    if black?
      return "&#9818;"
    else
      return "&#9812;"
    end
  end

end
