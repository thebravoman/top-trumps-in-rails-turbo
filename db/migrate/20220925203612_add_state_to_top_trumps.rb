class AddStateToTopTrumps < ActiveRecord::Migration[7.0]
  def change
    add_column :top_trumps, :state, :string
  end
end
