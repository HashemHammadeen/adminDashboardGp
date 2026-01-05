class CreateShopPointsWallets < ActiveRecord::Migration[7.0]
  def up
    create_table :shop_points_wallets, id: false do |t|
      t.uuid :shop_id, null: false
      t.integer :points_received, null: false, default: 0
      t.timestamp :last_updated, default: -> { 'CURRENT_TIMESTAMP' }
    end

    execute "ALTER TABLE shop_points_wallets ADD PRIMARY KEY (shop_id);"
    add_foreign_key :shop_points_wallets, :shops, column: :shop_id
  end

  def down
    drop_table :shop_points_wallets
  end
end