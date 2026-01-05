class CreateEarnTransactions < ActiveRecord::Migration[7.0]
  def up
    create_table :earn_transactions, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true, index: false
      t.references :shop, type: :uuid, null: false, foreign_key: true, index: false
      t.decimal :purchase_amount, precision: 10, scale: 2, null: false
      t.integer :points_earned, null: false
      t.string :transaction_ref

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :earn_transactions, :user_id
    add_index :earn_transactions, :shop_id
    add_index :earn_transactions, :created_at

    execute <<-SQL
      COMMENT ON COLUMN earn_transactions.transaction_ref IS 'actual receipt number(the white receipt)'
    SQL
  end

  def down
    drop_table :earn_transactions
  end
end
