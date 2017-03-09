class CreateMoves < ActiveRecord::Migration[5.0]
  def change
    create_table :moves do |t|
      t.integer :move_number
      t.text :from_position, array: true, default: []
      t.text :to_position, array: true, default: []
      t.string :move_type
      t.integer :game_id
      t.integer :piece_id

      t.timestamps
    end
    add_index :moves, :game_id
    add_index :moves, :piece_id
  end
end
