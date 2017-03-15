class ReplaceColorFromPieceWithIsBlack < ActiveRecord::Migration[5.0]
  def change
    remove_column :pieces, :color
    add_column :pieces, :is_black, :boolean
  end
end
