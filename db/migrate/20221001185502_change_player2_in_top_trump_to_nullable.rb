class ChangePlayer2InTopTrumpToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column :top_trumps, :player2_id, :integer, null: true, foreign_key: {to_table: :users}
  end
end
