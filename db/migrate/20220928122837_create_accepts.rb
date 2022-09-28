class CreateAccepts < ActiveRecord::Migration[7.0]
  def change
    create_table :accepts do |t|
      t.belongs_to :top_trump, null: false, foreign_key: true
      t.integer :trick
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
