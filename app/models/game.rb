class Game < ApplicationRecord
  has_many :participations
  has_many :pieces

  scope :available,
        lambda do
          where('(white_player_id IS NULL AND black_player_id IS NOT NULL)
          OR
          (white_player_id IS NOT NULL AND black_player_id IS NULL)')
        end
end
