class RenameCapturedFromPiecesToIsCaptured < ActiveRecord::Migration[5.0]
  def change
    rename_column :pieces, :captured, :is_captured
  end
end
