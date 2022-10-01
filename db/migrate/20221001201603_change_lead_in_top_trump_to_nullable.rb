class ChangeLeadInTopTrumpToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column :top_trumps, :lead_id, :integer, null: true, foreign_key: {to_table: :users}
  end
end
