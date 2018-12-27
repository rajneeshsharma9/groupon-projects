class AddInfiniteOptionToDealsLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :deals_locations, :finite_deal_quantity, :boolean, default: 0
  end
end
