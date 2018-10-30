class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.integer :role
      t.datetime :verified_at
      t.string :verification_token
      t.string :password_reset_token
      t.timestamps
    end
  end
end
