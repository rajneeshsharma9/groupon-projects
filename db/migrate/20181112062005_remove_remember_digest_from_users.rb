class RemoveRememberDigestFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :remember_digest
  end
end
