require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#create action" do
    it "should require user to be logged in to start a game" do
      Game.create(white_player_id: 1)
      post :create, id: game.id
      expect(response).to redirect_to new_user_session_path
    end
  end
end
