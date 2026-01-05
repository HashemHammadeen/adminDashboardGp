class CreateStamps < ActiveRecord::Migration[7.0]
  def up
    create_table :stamps, id: :uuid do |t|
      t.references :shop, type: :uuid, null: false, foreign_key: true, index: false
      t.string :name, null: false
      t.text :description
      t.integer :stamps_required, null: false
      t.string :reward_type, null: false
      t.jsonb :reward_value
      t.boolean :active, null: false, default: true
      t.timestamp :expiration_limit, null: false
      t.integer :stamps_limit
      t.timestamp :start_date, null: false
      t.timestamp :end_date

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :stamps, :shop_id
    add_index :stamps, :active

    execute <<-SQL
      COMMENT ON COLUMN stamps.reward_type IS 'free_item, discount'
    SQL
  end

  def down
    drop_table :stamps
  end
end