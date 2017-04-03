class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :moves

  scope :are_captured, -> { where(row: -1, col: -1) }
  scope :are_not_captured, -> { where("row > ? AND col > ?", -1, -1) }

  def self.types
    %w(Pawn Rook Knight Bishop Queen King)
  end

  # Adds an STI type property to the JSON data, rails doesn't do this by default
  def serializable_hash(options = nil)
    super.merge("type" => type)
  end

  def move_to!(to_row, to_col)
    Rails.logger.debug "MOVE TO MOVE TO MOVE TO MOVE TO "

    if valid_move?(to_row, to_col)
      logger.debug "VALID MOVE returned true"
    else
      logger.debug "VALID MOVE returned false"
    end

    # from_row = row
    # from_col = col
    # update_attributes(row: to_row, col: to_col)


    # create_move!(from_row, from_col)
  end

  def capture_piece(row, col)
    (enemy = enemy_at(row, col)) ? enemy.captured! : false
  end

  def captured!
    update(row: -1, col: -1)
  end

  def captured?
    row < 0 && col < 0
  end

  private

  def valid_move?(to_row, to_col)
    Rails.logger.debug "VALID MOVE updated code"
    return false if move_nil?(to_row, to_col)
    return false if move_out_of_bounds?(to_row, to_col)
    return false if move_destination_ally?(to_row, to_col)
    return false unless move_legal?(to_row, to_col)
    # return false if move_obstructed?(to_row, to_col)
    true
  end

  def move_nil?(to_row, to_col)
    Rails.logger.debug "MOVE NIL"
    row == to_row && col == to_col
  end

  def move_out_of_bounds?(to_row, to_col)
    Rails.logger.debug "OUT OF BOUNDS"
    to_row < 0 || to_row > 7 || to_col < 0 || to_col > 7
  end

  def move_destination_ally?(to_row, to_col)
    Rails.logger.debug "DESTINATION ALLY"
    ally_at(to_row, to_col)
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

    Rails.logger.debug "Obstruction array contains #{obstruction_array.size} elements"
    return false if obstruction_array.empty?
    obstruction_array.each do |square|
      if game.piece_at(square[0], square[1])
        Rails.logger.debug "OBSTRUCTION at #{square[0]}, #{square[1]}"
      end
      return true if game.piece_at(square[0], square[1])
    end
    false
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

  def enemy_at(check_row, check_col)
    enemy = game.piece_at(check_row, check_col)
    enemy if enemy && enemy.is_black != is_black
  end

  def ally_at(check_row, check_col)
    ally = game.piece_at(check_row, check_col)
    ally if ally && ally.is_black == is_black
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

end
