class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :adm_user
      t.string :api_address
      t.string :code
      t.string :access_token
      t.string :refresh_token
      t.datetime :token_expires_at

      t.timestamps
    end
  end
end
