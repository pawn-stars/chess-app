class AddIsBlacksMoveToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :is_blacks_move, :boolean
  end
end
