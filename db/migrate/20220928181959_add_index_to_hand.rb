class AddIndexToHand < ActiveRecord::Migration[7.0]
  def change
    add_column :hands, :index, :integer
  end
end
