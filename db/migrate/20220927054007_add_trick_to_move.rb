class AddTrickToMove < ActiveRecord::Migration[7.0]
  def change
    add_column :moves, :trick, :integer
  end
end
