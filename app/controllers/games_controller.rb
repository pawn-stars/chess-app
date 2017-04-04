class GamesController < ApplicationController
  def index
    @games = Game.available
  end

  def create
    game = Game.create(white_player_id: current_user.id)
    current_user.games << game
    redirect_to game
  end

  def new
    @game = Game.new
  end

  def show
    @game = Game.find(params[:id])
  end

  # Join a Game
  # Current_user_id becomes black_player_id
  # For given game assign (update) current_user_id to black_player_id

  def update
    @game = Game.find(params[:id])
    @game.update_attributes(game_params)
    if @game.valid?
      current_user.games << game
      redirect_to @game
    else
      render :index, text: "Not Allowed"
    end
  end

  def forfeit
    @game = Game.find(params[:id])
      if current_user.id == @game.white_player_id
        @game.update_attributes(winner: @game.black_player_id)
      end

      if current_user.id == @game.black_player_id
        @game.update_attributes(winner: @game.white_player_id)
      end

      redirect_to root_path
  end

  private

  def game_params
    params.require(:game).permit(:black_player_id)
  end
end
