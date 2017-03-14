require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "Join a Game" do
    let(:white_player){User.create(email: "Test@example.com", password: "123456", password_confirmation: "123456")}
    let(:game){Game.create(white_player_id: white_player.id)}
    let(:black_player){User.create(email: "Test2@example.com", password: "123456", password_confirmation: "123456")}
  it "should allow player to join game and update game params"
    patch :update, params: {black_player_id: black_player.id}
    expect(response).to redirect_to games_path
  end

end
