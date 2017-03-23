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
    Rails.logger.debug "Model move_to. from location: #{self.row},#{self.col} to location: #{to_row},#{to_col}"

    if valid_move?(to_row,to_col)
      from_row = self.row   # needed for create_move if valid_move? true
      from_col = self.col   # needed for create_move if valid_move? true
      Rails.logger.debug "valid_move result TRUE. Piece stays at new location. controller update UPDATES table."
      update_attributes(row: to_row, col: to_col)
    else
      Rails.logger.debug "valid move result FALSE. Piece should pop back to original location. controller update does NOT update database table."
    end   # method move_to!

    # origin code
    # raise "Out of bounds" if row < 0 || row > 7 || col < 0 || col > 7
    # update(row: row, col: col)
  end

  def valid_move?(to_row,to_col)
    return false if move_nil?(to_row,to_col)
    return false if move_out_of_bounds?(to_row,to_col)
    return false unless move_legal?(to_row,to_col)
    return false if move_obstructed?(to_row,to_col)
    return false if move_destination_obstructed(to_row,to_col)
    return true
  end   # method valid_move?

  def move_nil?(to_row, to_col)
    self.row == to_row && self.col == to_col
  end   # method move_nil?

  def move_out_of_bounds?(to_row,to_col)
    to_row < 0 || to_row > 7 || to_col < 0 || to_row > 7
  end   # method move_out_of_bounds?

  def move_legal?(to_row,to_col)
    # Piece sub-classes MUST implement move_legal? method. See King.rb for example
    # fail NotImplementedError 'Piece sub-class must implement #legal_move?'
    # Will remove comment and following code once all sub-classes are complete.

    if (self.type == "Knight")
      return true
    else
      self.row == to_row || self.col == to_col || (self.row-to_row).abs == (self.col-to_col).abs
    end

  end   # method move_legal

  def move_obstructed?(to_row,to_col)
    return false
  end   # move_obstructed

  def move_destination_obstructed(to_row,to_col)
    return false
  end   # move_destination_obstructed

end
