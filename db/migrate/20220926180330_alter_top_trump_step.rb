class AlterTopTrumpStep < ActiveRecord::Migration[7.0]
  def change
    change_column :top_trumps, :state, 'integer USING state::integer'
  end
end
