class RemoveConfirmedAtFromOrder < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :confirmed_at, :datetime
  end
end
