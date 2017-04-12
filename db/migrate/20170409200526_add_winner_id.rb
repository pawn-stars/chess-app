class AddWinnerId < ActiveRecord::Migration[5.0]
  def change
    rename_column :games, :winner, :winner_id
  end
end
