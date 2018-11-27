class AddCollectionRefToDeal < ActiveRecord::Migration[5.2]
  def change
    add_reference :deals, :collection, foreign_key: true
  end
end
