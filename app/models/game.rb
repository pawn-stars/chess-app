class Game < ApplicationRecord
  has_many :participations

  scope :available,
    # -> { where('(white_player_id = ? AND black_player_id != ?)
    #             OR
    #             (white_player_id != ? AND black_player_id = ?)',
    #             nil, nil, nil, nil) }
    -> { where('(white_player_id = ? OR black_player_id = ?)', nil, nil) }
end
