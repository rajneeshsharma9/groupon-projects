class AddStateRelatedColumnsToOrders < ActiveRecord::Migration[5.2]
  def change
    change_table :orders do |t|
      t.datetime :confirmed_at
      t.datetime :cancelled_at
      t.string :cancelled_by
      t.datetime :delivered_at
    end
  end
end
