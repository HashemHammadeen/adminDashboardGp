class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops, id: :uuid do |t|
      t.references :mall, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.references :category, type: :uuid, null: false, foreign_key: true
      t.boolean :is_active, default: true

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :shops, :name, unique: true
  end
end