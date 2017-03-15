class RemoveStartPositionFromPiece < ActiveRecord::Migration[5.0]
  def change
    remove_column :pieces, :start_position
  end
end
