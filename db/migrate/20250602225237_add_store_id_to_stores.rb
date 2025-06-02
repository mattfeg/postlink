class AddStoreIdToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :store_id, :string
  end
end
