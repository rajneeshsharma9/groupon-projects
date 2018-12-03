class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.references :deal
      t.references :order
      t.decimal :price, precision: 6, scale: 2, default: 0
      t.integer :quantity, default: 0
      t.timestamps
    end
  end
end
