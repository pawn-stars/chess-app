class Bishop < Piece

  def display_piece
    if black?
      return "&#9821;"
    else
      return "&#9815;"
    end
  end

end
