class AddTitleAndDescriptionToCard < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :title, :string
    add_column :cards, :description, :string
  end
end
