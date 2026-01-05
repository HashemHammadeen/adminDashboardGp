class CreateOffers < ActiveRecord::Migration[7.0]
  def up
    create_table :offers, id: :uuid do |t|
      t.references :shop, type: :uuid, null: false, foreign_key: true, index: false
      t.string :name, null: false
      t.text :description
      t.string :reward_type, null: false
      t.jsonb :reward_value
      t.integer :redemptions_count
      t.boolean :active, null: false, default: true
      t.timestamp :start_date, null: false
      t.timestamp :end_date

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :offers, :shop_id
    add_index :offers, :active

    execute <<-SQL
      COMMENT ON COLUMN offers.reward_type IS 'free_item, discount, points'
    SQL
  end

  def down
    drop_table :offers
  end
end
