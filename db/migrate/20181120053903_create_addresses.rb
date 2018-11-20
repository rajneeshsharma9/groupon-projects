class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :street_address
      t.string :state
      t.string :city
      t.string :country
      t.string :pincode
      t.references :location
      t.timestamps
    end
  end
end
