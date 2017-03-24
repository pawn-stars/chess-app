class ChangeFromPositionAndToPositionTypes < ActiveRecord::Migration[5.0]
  def change
    remove_column :moves, :from_position
    remove_column :moves, :to_position
    add_column :moves, :from_position, :integer, array: true, default: []
    add_column :moves, :to_position, :integer, array: true, default: []
  end
end
