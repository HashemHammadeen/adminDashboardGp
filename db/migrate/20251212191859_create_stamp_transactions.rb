class CreateStampTransactions < ActiveRecord::Migration[7.0]
  def up
    create_table :stamp_transactions, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true, index: false
      t.references :shop, type: :uuid, null: false, foreign_key: true, index: false
      t.references :stamp, type: :uuid, null: false, foreign_key: true, index: false
      t.string :type, null: false
      t.integer :stamps_count, null: false
      t.uuid :redemption_ref

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :stamp_transactions, :user_id
    add_index :stamp_transactions, :shop_id
    add_index :stamp_transactions, :stamp_id
    add_index :stamp_transactions, :type
    add_index :stamp_transactions, :created_at

    # Add foreign key to receipts - Rails uses 'id' as primary key by default
    add_foreign_key :stamp_transactions, :receipts, column: :redemption_ref, primary_key: :id

    execute <<-SQL
      COMMENT ON COLUMN stamp_transactions.type IS 'activation, stamp, redeem_reward'
    SQL
  end

  def down
    drop_table :stamp_transactions
  end
end