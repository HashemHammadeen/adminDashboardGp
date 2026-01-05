class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :category_name, null: false
      t.text :description

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :categories, :category_name, unique: true
  end
end