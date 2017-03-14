class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :participations
  has_many :games, through: :participations

  validates :screen_name, presence: true,
                          length: { maximum: 16, minimum: 3 },
                          format: { with: /\A\w+\z/,
                                    message: "only allows letters and numbers" }
end
