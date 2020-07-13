class AddQuantityToDealsLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :deals_locations, :total_deals, :integer, default: 0
    add_column :deals_locations, :deals_sold, :integer, default: 0
  end
end
