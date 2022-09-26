class AddUserToMoves < ActiveRecord::Migration[7.0]
  def change
    add_reference :moves, :user, null: false, foreign_key: true
  end
end
