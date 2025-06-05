class AddStoreHostToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :store_host, :string
  end
end
