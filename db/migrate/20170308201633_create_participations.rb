class CreateParticipations < ActiveRecord::Migration[5.0]
  def change
    create_table :participations do |t|
      t.integer :user_id
      t.integer :game_id

      t.timestamps
    end
    add_index :participations, [:user_id, :game_id]
    add_index :participations, :game_id
  end
end
