class RemoveRequiredOnMovesCardCategory < ActiveRecord::Migration[7.0]
  def change
    change_column :moves, :card_category_id, :integer, null: true
    remove_index :moves, :card_category_id
  end
end
