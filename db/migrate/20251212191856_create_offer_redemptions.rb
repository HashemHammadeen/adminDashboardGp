class CreateOfferRedemptions < ActiveRecord::Migration[7.0]
  def up
    create_table :offer_redemptions, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true, index: false
      t.references :offer, type: :uuid, null: false, foreign_key: true, index: false
      t.references :shop, type: :uuid, null: false, foreign_key: true, index: false
      t.uuid :redemption_ref

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :offer_redemptions, :user_id
    add_index :offer_redemptions, :offer_id
    add_index :offer_redemptions, :shop_id

    # Add foreign key to receipts - Rails uses 'id' as primary key by default
    add_foreign_key :offer_redemptions, :receipts, column: :redemption_ref, primary_key: :id
  end

  def down
    drop_table :offer_redemptions
  end
end