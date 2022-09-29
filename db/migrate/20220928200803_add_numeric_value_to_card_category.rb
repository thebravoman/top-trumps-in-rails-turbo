class AddNumericValueToCardCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :card_categories, :numeric_value, :integer
  end
end
