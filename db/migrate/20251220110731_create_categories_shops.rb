class CreateCategoriesShops < ActiveRecord::Migration[8.1]
  def up
    create_table :categories_shops, id: false do |t|
      t.belongs_to :shop, type: :uuid, null: false, foreign_key: true
      t.belongs_to :category, type: :uuid, null: false, foreign_key: true
    end

    add_index :categories_shops, [:shop_id, :category_id], unique: true

    # Migrate existing data
    # Using raw SQL to avoid model dependency issues
    execute <<-SQL
      INSERT INTO categories_shops (shop_id, category_id)
      SELECT id, category_id FROM shops WHERE category_id IS NOT NULL
    SQL

    remove_column :shops, :category_id
  end

  def down
    add_reference :shops, :category, type: :uuid, foreign_key: true

    # Attempt to restore data (picking one category arbitrarily)
    execute <<-SQL
      UPDATE shops
      SET category_id = (
        SELECT category_id FROM categories_shops
        WHERE categories_shops.shop_id = shops.id
        LIMIT 1
      )
    SQL

    drop_table :categories_shops
  end
end
