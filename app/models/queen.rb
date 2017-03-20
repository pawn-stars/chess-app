class Queen < Piece

  def display_piece
    if black?
      return "&#9819;"
    else
      return "&#9813;"
    end
  end

end
