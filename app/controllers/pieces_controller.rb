class PiecesController < ApplicationController
  def index
    game_id = params[:game_id]
    render json: Game.find(game_id).pieces
  end

  def update
    piece = Piece.find(params[:id])
    Rails.logger.debug "PIECE Controller Update. call move_to in pieces model"

    if piece.move_to!(piece_params[:row].to_i, piece_params[:col].to_i)
      Rails.logger.debug "VALID MOVE. Update Record - SQL update in server window"
      piece.update_attributes(piece_params)
    else
      Rails.logger.debug "INVALID MOVE. Do not update record. Piece will pop back on game page refresh"
    end
    render json: piece
  end

  private

  def piece_params
    params.require(:piece).permit(:row, :col)
  end
end
