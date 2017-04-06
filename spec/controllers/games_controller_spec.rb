require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  it "should require user to be logged in to start a game" do
    post :create, id: games
    expect(response).to redirect_to new_user_session_path
  end
end
