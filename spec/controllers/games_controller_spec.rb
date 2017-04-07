require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#forfeit action" do
    it "should show white player as winner if black player forfeits" do
      white = User.create(
        email: 'white@test.com',
        screen_name: 'white_player',
        password: '123456',
        password_confirmation: '123456'
      )
      black = User.create(
        email: 'black@test.com',
        screen_name: 'black_player',
        password: '123456',
        password_confirmation: '123456'
      )
      game = Game.create(white_player_id: white.id, black_player_id: black.id)
      post :forfeit, params: {id: game.id}

      expect(response).to redirect_to(games_path)
    end
  end
end
