require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#create action" do
    it "should require user to be logged in to start a game" do
      game = Game.create
      post :create, params: { id: game.id }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "games#update action" do
    it "should require user to be logged in to join a game" do
      game = Game.create
      patch :update, params: { id: game.id }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "games#show action" do
    it "should require user to be logged in to show a game" do
      game = Game.create
      get :show, params: { id: game.id }
      expect(response).to redirect_to new_user_session_path
    end
  end
end

