class AddValueToCardCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :card_categories, :value, :string
  end
end
