class GamesController < ApplicationController

  def index
    @games = Game.available
  end

  def create
    # For Development Purposes Only - Used to test Available list.
    Game.create(white_player_id: 1)

    redirect_to games_path

  end

  def new
    @game = Game.new
  end

  def show
  end

# Join a Game
# Current_user_id becomes black_player_id
# For given game assign (update) current_user_id to black_player_id

  def update
    @game = Game.find(params[:id])

    @game.update_attributes(game_params)
    if @game.valid?
      redirect_to games_path
    else
      render :index, text: "Not Allowed"
    end
  end
  

  private

  def game_params
    params.require(:game).permit(:black_player_id, :white_player_id)
  end


end
