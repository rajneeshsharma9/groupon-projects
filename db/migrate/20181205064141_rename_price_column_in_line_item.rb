class RenamePriceColumnInLineItem < ActiveRecord::Migration[5.2]
  def change
    change_table :line_items do |t|
      t.rename :price, :price_per_quantity
    end
  end
end
