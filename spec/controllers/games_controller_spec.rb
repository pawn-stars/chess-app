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
      post :forfeit, params: {id: game.id, game: { black_player_id: black.id} }

      expect(response).to redirect_to(games_path)
    end
  end

  describe "games#create action" do
    it "should require user to be logged in to start a game" do
      game = Game.create
      post :create, params: { id: game.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow logged in user to start a game" do
      user = User.create(
        email: 'test@test.com',
        screen_name: 'test',
        password: '123456',
        password_confirmation: '123456'
      )
      sign_in user

      game = Game.create
      post :create, params: { id: game.id }
      expect(response).to redirect_to(Game.last)
    end
  end

  describe "games#update action" do
    it "should require user to be logged in to join a game" do
      game = Game.create
      patch :update, params: { id: game.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow logged in user to join a game" do
      @user = User.create(
        email: 'test@test.com',
        screen_name: 'test',
        password: '123456',
        password_confirmation: '123456'
      )
      sign_in @user

      game = Game.create
      patch :update, params: { id: game.id, game: { black_player_id: @user } }
      expect(response).to redirect_to game
    end
  end

  describe "games#show action" do
    it "should require user to be logged in to show a game" do
      game = Game.create
      get :show, params: { id: game.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow logged in user to show a game" do
      @user = User.create(
        email: 'test@test.com',
        screen_name: 'test',
        password: '123456',
        password_confirmation: '123456'
      )
      sign_in @user

      game = Game.create
      get :show, params: { id: game.id }
      expect(response).to have_http_status(:success)
    end
  end
end
