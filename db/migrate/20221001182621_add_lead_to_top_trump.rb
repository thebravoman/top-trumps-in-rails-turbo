class AddLeadToTopTrump < ActiveRecord::Migration[7.0]
  def change
    add_reference :top_trumps, :lead, null: false, foreign_key: {to_table: :users}
  end
end
