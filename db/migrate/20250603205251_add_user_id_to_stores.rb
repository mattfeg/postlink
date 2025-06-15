class AddUserIdToStores < ActiveRecord::Migration[8.0]
  def change
    add_reference :stores, :user, foreign_key: true
  end
end
