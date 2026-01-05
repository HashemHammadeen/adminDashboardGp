class CreateMallAdmins < ActiveRecord::Migration[7.0]
  def up
    create_table :mall_admins, id: :uuid do |t|
      t.references :mall, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :password_hash, null: false

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :mall_admins, :email, unique: true
    add_index :mall_admins, :phone, unique: true

    execute <<-SQL
      COMMENT ON TABLE mall_admins IS 'Manages entire mall - can view all shops in their mall'
    SQL
  end

  def down
    drop_table :mall_admins
  end
end