class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.references :shop, type: :uuid, foreign_key: true
      t.references :receipt, type: :uuid, foreign_key: true
      t.integer :amount, null: false
      t.timestamp :created_at, null: false
    end
  end
end