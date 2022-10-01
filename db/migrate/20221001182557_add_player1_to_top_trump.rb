class AddPlayer1ToTopTrump < ActiveRecord::Migration[7.0]
  def change
    add_reference :top_trumps, :player1, null: false, foreign_key: {to_table: :users}
  end
end
