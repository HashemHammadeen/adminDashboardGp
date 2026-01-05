class CreateReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :receipts, id: :uuid do |t|
      t.string :receipt_path
      t.references :shop, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.integer :amount, null: false
      t.jsonb :receipt_details, null: false
    end
  end
end
