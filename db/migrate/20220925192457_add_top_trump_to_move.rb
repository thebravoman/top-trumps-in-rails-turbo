
class AddTopTrumpToMove < ActiveRecord::Migration[7.0]
  def change
    add_reference :moves, :top_trump, null: false, foreign_key: true
  end
end
