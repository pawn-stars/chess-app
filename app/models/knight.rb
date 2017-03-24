class Knight < Piece

  def display_piece
    if black?
      return "&#9822;"
    else
      return "&#9816;"
    end
  end

end
