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

  def move_to!(row, col)
    raise "Out of bounds" if row < 0 || row > 7 || col < 0 || col > 7
    create_move!(row, col)
    update(row: row, col: col)
  end

  private

  def create_move!(new_row, new_col)
    last_move_number = game.moves.last ? game.moves.last.move_number : 0
    moves.create(
      move_number: last_move_number + 1,
      from_position: [row, col],
      to_position: [new_row, new_col],
      move_type: nil, # to be implemented later
      game_id: game.id
    )
  end
end
