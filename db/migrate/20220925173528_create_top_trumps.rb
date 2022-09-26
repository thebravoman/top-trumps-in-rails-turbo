class CreateTopTrumps < ActiveRecord::Migration[7.0]
  def change
    create_table :top_trumps do |t|

      t.timestamps
    end
  end
end
