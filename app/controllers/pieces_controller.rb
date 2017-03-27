class PiecesController < ApplicationController
  def index
    game_id = params[:game_id]
    render json: Game.find(game_id).pieces
  end

  def update
    piece = Piece.find(params[:id])

    if piece.move_to!(piece_params[:row].to_i, piece_params[:col].to_i)
      Rails.logger.debug "Piece move to #{piece.row}, #{piece.col} is GOOD"
    else
      Rails.logger.debug "ERROR. PIECE SHOULD NOT MOVE"
    end

    render json: piece
  end

  private

  def piece_params
    params.require(:piece).permit(:row, :col)
  end
end
