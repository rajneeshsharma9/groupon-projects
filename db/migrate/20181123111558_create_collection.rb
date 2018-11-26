class CreateCollection < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
      t.string :name
      t.datetime :published_at
      t.timestamps
    end
  end
end
