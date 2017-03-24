class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :moves

  scope :are_captured, -> { where(is_captured: true) }
  scope :are_not_captured, -> { where(is_captured: false) }

  def self.types
    %w(Pawn Rook Knight Bishop Queen King)
  end

  # Adds an STI type property to the JSON data, rails doesn't do this be default
  def serializable_hash(options = nil)
    super.merge("type" => type)
  end

  def move_to!(to_row, to_col)
    # rubocop: disable LineLength
    Rails.logger.debug "Model move_to. from: #{row},#{col} to: #{to_row},#{to_col}"

    if valid_move?(to_row, to_col)
      from_row = row   # needed for create_move if valid_move? true
      from_col = col   # needed for create_move if valid_move? true
      Rails.logger.debug "valid_move result TRUE. Piece stays at new location."
      update_attributes(row: to_row, col: to_col)
      create_move!(from_row, from_col)
    else
      Rails.logger.debug "valid move result FALSE. Piece pop back when games show page reloaded."
    end # method move_to!
  end   # method move_to!

  private

  def valid_move?(to_row, to_col)
    return false if move_nil?(to_row, to_col)
    return false if move_out_of_bounds?(to_row, to_col)
    return false unless move_legal?(to_row, to_col)
    return false if move_obstructed?(to_row, to_col)
    return false if move_destination_obstructed(to_row, to_col)
    true
  end   # method valid_move?

  def move_nil?(to_row, to_col)
    row == to_row && col == to_col
  end   # method move_nil?

  def move_out_of_bounds?(to_row, to_col)
    to_row < 0 || to_row > 7 || to_col < 0 || to_row > 7
  end   # method move_out_of_bounds?

  def move_legal?(to_row, to_col)
    # Piece sub-classes MUST implement move_legal? method. See King.rb for example
    # fail NotImplementedError 'Piece sub-class must implement #legal_move?'
    # Will remove comment and following code once all sub-classes are complete.

    if type == "Knight"
      true
    else
      row == to_row || col == to_col || (row - to_row).abs == (col - to_col).abs
    end
  end   # method move_legal

  def move_obstructed?(_to_row, _to_col)
    false
  end   # move_obstructed

  def move_destination_obstructed(_to_row, _to_col)
    false
  end # method move_destination_obstructed

  def create_move!(from_row, from_col)
    last_move_number = game.moves.last ? game.moves.last.move_number : 0
    moves.create(
      move_number: last_move_number + 1,
      from_position: [from_row, from_col],
      to_position: [row, col],
      move_type: nil, # to be implemented later
      game_id: game.id
    )
  end # method create_move!
end
