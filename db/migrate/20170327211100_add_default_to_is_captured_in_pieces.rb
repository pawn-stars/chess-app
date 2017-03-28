class AddDefaultToIsCapturedInPieces < ActiveRecord::Migration[5.0]
  def change
    change_column(:pieces, :is_captured, :boolean, default: false)
  end
end
