class CreateRedeemTransactions < ActiveRecord::Migration[7.0]
  def up
    create_table :redeem_transactions, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true, index: false
      t.references :shop, type: :uuid, null: false, foreign_key: true, index: false
      t.integer :points_used, null: false
      t.decimal :discount_value, precision: 10, scale: 2, null: false
      t.string :verification_code, limit: 6, null: false
      t.string :status, null: false, default: 'pending'
      t.timestamp :created_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :completed_at
    end

    add_index :redeem_transactions, :user_id
    add_index :redeem_transactions, :shop_id
    add_index :redeem_transactions, :status
    add_index :redeem_transactions, :verification_code
    add_index :redeem_transactions, :created_at

    execute <<-SQL
      COMMENT ON COLUMN redeem_transactions.status IS 'pending, verified, completed, cancelled'
    SQL
  end

  def down
    drop_table :redeem_transactions
  end
end