class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :moves

  scope :are_captured, -> { where(is_captured: true) }
  scope :are_not_captured, -> { where(is_captured: false) }

  def self.types
    %w(Pawn Rook Knight Bishop Queen King)
  end

  # Adds an STI type property to the JSON data, rails doesn't do this by default
  def serializable_hash(options = nil)
    super.merge("type" => type)
  end

  def move_to!(to_row, to_col)
    return false unless valid_move?(to_row, to_col)

    from_row = row
    from_col = col
    update_attributes(row: to_row, col: to_col)
    create_move!(from_row, from_col)
    true
  end

  private

  def valid_move?(to_row, to_col)
    return false if move_nil?(to_row, to_col)
    return false if move_out_of_bounds?(to_row, to_col)
    return false unless move_legal?(to_row, to_col)
    return false if move_obstructed?(to_row, to_col)
    return false if move_destination_obstructed?(to_row, to_col)
    true
  end

  def move_nil?(to_row, to_col)
    row == to_row && col == to_col
  end

  def move_out_of_bounds?(to_row, to_col)
    to_row < 0 || to_row > 7 || to_col < 0 || to_col > 7
  end

  def move_legal?(to_row, to_col)
    # Piece sub-classes MUST implement move_legal? method. See King.rb for example
    # fail NotImplementedError 'Piece sub-class must implement #legal_move?'
    # Will remove comment and following code once all sub-classes are complete.

    if type == "Knight"
      true
    else
      row == to_row || col == to_col || (row - to_row).abs == (col - to_col).abs
    end
  end

  def move_obstructed?(to_row, to_col)
    Rails.logger.debug "***** Move_obstructed from #{row},#{col} to #{to_row},#{to_col}"
    if type == "Knight"
      Rails.logger.debug "KNIGHT. cannot obstruct move"
      false
    end

    obstruction_array = []
    if row == to_row
      obstruction_array = move_obstructed_horizontal(to_col)
    elsif col == to_col
      obstruction_array = move_obstructed_vertical(to_row)
    elsif (row - to_row).abs == (col - to_col).abs
      obstruction_array = move_obstructed_diagonal(to_row, to_col)
    end

    # Rails.logger.debug "Obstruction array contains #{obstruction_array.size} elements"
    return false if obstruction_array.empty?
    obstruction_array.each do |square|
      return true if game.piece_at(square[0], square[1])
    end

    false
  end

  def move_obstructed_horizontal(to_col)
    obstruction_array = []
    col_direction = to_col > col ? 1 : -1
    current_col = col + col_direction
    while (to_col - current_col).abs > 0
      obstruction_array << [row, current_col]
      current_col += col_direction
    end
    Rails.logger.debug "Horizonal Move. Inspect #{obstruction_array.size} squares"
    obstruction_array
  end

  def move_obstructed_vertical(to_row)
    obstruction_array = []
    row_direction = to_row > row ? 1 : -1
    current_row = row + row_direction
    while (to_row - current_row).abs > 0
      obstruction_array << [current_row, col]
      current_row += row_direction
    end
    Rails.logger.debug "Vertical Move. Inspect #{obstruction_array.size} squares"
    obstruction_array
  end

  def move_obstructed_diagonal(to_row, to_col)
    obstruction_array = []
    col_direction = to_col > col ? 1 : -1
    row_direction = to_row > row ? 1 : -1
    current_col = col + col_direction
    current_row = row + row_direction
    while (to_row - current_row).abs > 0 && (to_col - current_col).abs > 0
      obstruction_array << [current_row, current_col]
      current_col += col_direction
      current_row += row_direction
    end
    Rails.logger.debug "Diagonal Move. Inspect #{obstruction_array.size} squares"
    obstruction_array
  end

  def move_destination_obstructed?(to_row, to_col)
    other_piece = game.piece_at(to_row, to_col)
    if other_piece
      side = "White"
      side = "Black" unless other_piece.is_black
      Rails.logger.debug "Destination NOT CLEAR. #{side} #{other_piece.type} at destination."
      if other_piece.user == user
        Rails.logger.debug "   DESTINATION CONTAINS SAME SIDE PIECE. ERROR"
        true
      else
        Rails.logger.debug "   Destination contains opponent piece. capture possible."
        # call capture logic
        other_piece.update(is_captured: true)
        false
      end
    else
      Rails.logger.debug "Destination EMPTY. return false."
      false
    end
  end

  # moved capture piece methods to private - after verify that move to new square is valid
  def capture_piece(row, col)
    other_piece = game.piece_at(row, col)
    # raise 'You cannot capture your own piece' if other_piece && other_piece.user == user
    other_piece.captured!
    return true if other_piece && other_piece.user != user
  end

  # This updates a piece to captured
  def captured!
    update(is_captured: true)
  end

  def captured?
    is_captured == true
  end

  def create_move!(from_row, from_col)
    last_move_number = game.moves.last ? game.moves.last.move_number : 0
    moves.create(
      move_number: last_move_number + 1,
      from_position: [from_row, from_col],
      to_position: [row, col],
      move_type: nil, # to be implemented later
      game_id: game.id
    )
  end
end
