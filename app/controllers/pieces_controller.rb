class PiecesController < ApplicationController
  def index
    game_id = params[:game_id]
    render json: Game.find(game_id).pieces
  end

  def update
    piece = Piece.find(params[:id])
    piece.move_to!(piece_params[:row].to_i, piece_params[:col].to_i)
    render json: piece.game.pieces
  end

  private

  def piece_params
    params.require(:piece).permit(:row, :col)
  end
end
