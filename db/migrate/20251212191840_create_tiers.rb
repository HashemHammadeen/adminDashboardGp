class CreateTiers < ActiveRecord::Migration[7.0]
  def change
    create_table :tiers, id: :uuid do |t|
      t.string :tier_name, null: false
      t.integer :points_required, null: false, default: 0
      t.jsonb :benefits

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :tiers, :tier_name, unique: true

    reversible do |dir|
      dir.up do
        execute "COMMENT ON COLUMN tiers.tier_name IS 'Bronze, Silver, Gold, Platinum';"
        execute "COMMENT ON COLUMN tiers.benefits IS 'Multipliers, perks, etc';"
      end
    end
  end
end