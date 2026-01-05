class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.string :password_hash, null: false
      t.string :gender, null: false
      t.references :tier, type: :uuid, null: false, foreign_key: true

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :users, :phone, unique: true
    add_index :users, :email, unique: true

    reversible do |dir|
      dir.up do
        execute "COMMENT ON TABLE users IS 'Regular customers who earn points';"
      end
    end
  end
end