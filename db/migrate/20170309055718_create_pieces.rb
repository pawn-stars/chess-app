class CreatePieces < ActiveRecord::Migration[5.0]
  def change
    create_table :pieces do |t|
      t.string :type
      t.string :color
      t.text :start_position, array: true, default: []
      t.integer :row
      t.integer :col
      t.boolean :captured

      t.timestamps
    end
  end
end
