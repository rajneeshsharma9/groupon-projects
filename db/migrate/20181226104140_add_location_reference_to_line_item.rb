class AddLocationReferenceToLineItem < ActiveRecord::Migration[5.2]
  def change
    add_reference :line_items, :location, foreign_key: true
  end
end
