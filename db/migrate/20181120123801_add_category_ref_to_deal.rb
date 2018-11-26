class AddCategoryRefToDeal < ActiveRecord::Migration[5.2]
  def change
    add_reference :deals, :category, foreign_key: true
  end
end
