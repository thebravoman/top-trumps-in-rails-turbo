class CreateMoves < ActiveRecord::Migration[7.0]
  def change
    create_table :moves do |t|
      t.belongs_to :card_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
