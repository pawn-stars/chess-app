class Game < ApplicationRecord
  has_many :participations

  scope :available, -> { where('white_player_id = ? OR black_player_id = ?', nil}
end
