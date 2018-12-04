class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user
      t.decimal :amount, precision: 7, scale: 2, default: 0.01
      t.string :workflow_state
      t.string :receiver_email
      t.timestamps
    end
  end
end
