class CreatePaymentsAndRefundsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :order
      t.string :charge_id
      t.string :transaction_id
      t.string :source_id
      t.string :last_four_card_digits
      t.integer :state
      t.decimal :amount_captured, precision: 7, scale: 2, default: 0.01
      t.text :charge_data
      t.timestamps
    end

    create_table :refunds do |t|
      t.references :payment
      t.references :line_item
      t.decimal :amount_refunded, precision: 7, scale: 2, default: 0.01
      t.string :refund_id
      t.text :refund_data
      t.timestamps
    end
  end
end
