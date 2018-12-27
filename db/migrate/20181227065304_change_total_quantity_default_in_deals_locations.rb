class ChangeTotalQuantityDefaultInDealsLocations < ActiveRecord::Migration[5.2]
  def change
    change_column_default :deals_locations, :total_deals, from: 0, to: nil
  end
end
