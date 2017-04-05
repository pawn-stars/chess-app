# rubocop:disable Metrics/AbcSize

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

    if @game.white_player_id != current_user && @game.black_player_id.nil?
      @game.update_attributes(black_player_id: current_user.id)
    end

    if @game.valid?
      current_user.games << @game
      @game.populate_board if @game.pieces.empty?
      redirect_to @game
    else
      render :index, text: "Not Allowed"
    end
  end

  def forfeit
    @game = Game.find(params[:id])

    if current_user.id == @game.white_player_id
      @game.update_attributes(winner: @game.black_player_id, result: 'Forfeit')
    end

    if current_user.id == @game.black_player_id
      @game.update_attributes(winner: @game.white_player_id, result: 'Forfeit')
    end

    flash[:alert] = 'You have forfeited the game.'
    redirect_to games_path
  end

  private

  def game_params
    params.require(:game).permit(:black_player_id)
  end
end
