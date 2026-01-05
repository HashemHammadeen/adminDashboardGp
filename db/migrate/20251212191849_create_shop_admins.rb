class CreateShopAdmins < ActiveRecord::Migration[7.0]
  def up
    create_table :shop_admins, id: :uuid do |t|
      t.references :shop, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :password_hash, null: false
      t.boolean :is_active, default: true

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :shop_admins, :email, unique: true
    add_index :shop_admins, :phone, unique: true

    execute <<-SQL
      COMMENT ON TABLE shop_admins IS 'Manages specific shop - can create programs, verify redemptions'
    SQL
  end

  def down
    drop_table :shop_admins
  end
end