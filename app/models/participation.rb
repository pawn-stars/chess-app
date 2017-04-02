class Participation < ApplicationRecord
  belongs_to :game
  belongs_to :user

  validate :max_two_players_per_game

  def max_two_players_per_game
    return if Participation.where(game_id: game_id).count < 2
    errors.add(:game_id, "Game already has two players")
  end
end
