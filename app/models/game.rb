class Game < ApplicationRecord
  has_many :participations

  scope :available,
    -> { where('(white_player_id IS NULL AND black_player_id IS NOT NULL)
                OR
                (white_player_id IS NOT NULL AND black_player_id IS NULL)') }
end
