class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :participations
  has_many :games, through: :participations
  has_many :pieces

  validates :screen_name, presence: true,
                          length: { maximum: 16, minimum: 3 },
                          format: { with: /\A\w+\z/,
                                    message: "only allows letters and numbers" }
  validates :validate_max_players_per_game

  def validate_max_players_per_game
    if game.users.count == 2
      errors.add(:games, "Game already has two players")
    end
  end
end
