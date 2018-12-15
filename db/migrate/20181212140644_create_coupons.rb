class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.references :line_item
      t.string :code
      t.datetime :redeemed_at
      t.references :redeemed_by
      t.timestamps
    end
  end
end
