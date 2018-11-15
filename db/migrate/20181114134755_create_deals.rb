class CreateDeals < ActiveRecord::Migration[5.2]
  def change
    create_table :deals do |t|
      t.string :title
      t.text :description
      t.integer :minimum_purchases_required, default: 0
      t.integer :maximum_purchases_allowed
      t.datetime :start_time
      t.datetime :expire_time
      t.decimal :price, precision: 6, scale: 2
      t.integer :maximum_purchases_per_customer
      t.text :instructions
      t.timestamps
    end
  end
end
