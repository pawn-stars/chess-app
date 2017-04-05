# rubocop:disable Metrics/CyclomaticComplexity
class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :moves

  scope :are_captured, -> { where(row: -1, col: -1) }
  scope :are_not_captured, -> { where("row > ? AND col > ?", -1, -1) }
  scope :ally_king, ->(is_black) { where(is_black: is_black).where(type: 'King') }

  def self.types
    %w(Pawn Rook Knight Bishop Queen King)
  end

  # Adds an STI type property to the JSON data, rails doesn't do this by default
  def serializable_hash(options = nil)
    super.merge("type" => type)
  end

  def move_to!(to_row, to_col)
    return false unless valid_move?(to_row, to_col)
    # en passant capture won't work if the line below executes after updating coords
    capture_piece(to_row, to_col)

    from_row = row
    from_col = col
    update_attributes(row: to_row, col: to_col)
    create_move!(from_row, from_col)
    true
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

  def move_nil?(to_row, to_col)
    row == to_row && col == to_col
  end

  def move_out_of_bounds?(to_row, to_col)
    to_row < 0 || to_row > 7 || to_col < 0 || to_col > 7
  end

  def move_destination_ally?(to_row, to_col)
    ally = game.piece_at(to_row, to_col)
    ally && ally.is_black == is_black ? true : false
  end

  def move_legal?(to_row, to_col)
    # Piece sub-classes MUST implement move_legal? method. See King.rb for example
    # fail NotImplementedError 'Piece sub-class must implement #legal_move?'
    # Will remove comment and following code once all sub-classes are complete.

    row == to_row || col == to_col || (row - to_row).abs == (col - to_col).abs
  end

  def move_obstructed?(to_row, to_col)
    row_direction = to_row <=> row
    col_direction = to_col <=> col

    current_row = row + row_direction
    current_col = col + col_direction

    until current_row == to_row && current_col == to_col
      return true if game.piece_at(current_row, current_col)
      current_row += row_direction
      current_col += col_direction
    end
    false
  end

  def self_check?(to_row, to_col)
    from_row = row
    from_col = col
    update(row: to_row, col: to_col)
    in_check = game.pieces.ally_king(is_black).first.in_check?
    update(row: from_row, col: from_col)
    in_check
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

  protected

  def valid_move?(to_row, to_col)
    return false if move_nil?(to_row, to_col)
    return false if move_out_of_bounds?(to_row, to_col)
    return false if move_destination_ally?(to_row, to_col)
    return false unless move_legal?(to_row, to_col)
    return false if move_obstructed?(to_row, to_col)
    return false if self_check?(to_row, to_col)
    true
  end
end
