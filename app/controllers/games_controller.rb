class GamesController < ApplicationController

  def index
    @games = Game.all
  end

  def create
    @game = Game.new(game_params)
  end

  def show
  end

  private

  def game_params
    params.require(:games).permit(:white_player_id, :black_player_id)
  end

end
