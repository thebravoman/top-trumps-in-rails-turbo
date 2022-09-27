class AddCurrentTrickToTopTrump < ActiveRecord::Migration[7.0]
  def change
    add_column :top_trumps, :current_trick, :integer, default: 1
  end
end
