class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show

  end

  def losses(current_user)
    return true if @game.winner_id.present? && winner_id != current_user.id
  end

end
