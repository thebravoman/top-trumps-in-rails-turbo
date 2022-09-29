class CreateHands < ActiveRecord::Migration[7.0]
  def change
    create_table :hands do |t|
      t.references :top_trump
      t.timestamps
    end
  end
end
