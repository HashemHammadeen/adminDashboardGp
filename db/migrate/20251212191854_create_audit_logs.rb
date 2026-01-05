class CreateAuditLogs < ActiveRecord::Migration[7.0]
  def up
    create_table :audit_logs, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, index: false
      t.references :shop, type: :uuid, foreign_key: true, index: false
      t.uuid :admin_id
      t.string :admin_type
      t.string :action_type, null: false
      t.integer :points
      t.jsonb :metadata

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :audit_logs, :user_id
    add_index :audit_logs, :shop_id
    add_index :audit_logs, :action_type
    add_index :audit_logs, :created_at

    execute <<-SQL
      COMMENT ON COLUMN audit_logs.admin_id IS 'Could be mall_admin_id or shop_admin_id';
      COMMENT ON COLUMN audit_logs.admin_type IS 'mall_admin, shop_admin';
      COMMENT ON COLUMN audit_logs.action_type IS 'earn, redeem, admin_adjust, tier_change';
    SQL
  end

  def down
    drop_table :audit_logs
  end
end
