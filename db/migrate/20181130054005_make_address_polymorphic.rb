class MakeAddressPolymorphic < ActiveRecord::Migration[5.2]
  def change
    change_table :addresses do |t|
      t.remove :location_id
      t.references :addressable, polymorphic: true, index: true
    end
  end
end
