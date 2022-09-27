class AddCardToMove < ActiveRecord::Migration[7.0]
  def change
    add_reference :moves, :card, null: false, foreign_key: true
  end
end
