class CreateDealsLocationsJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :deals_locations do |t|
      t.references :deal
      t.references :location
      t.timestamps
    end
  end
end
