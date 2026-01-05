class CreateSystemConfigurationsAndPointValueHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :system_configurations, id: :uuid do |t|
      t.string :key, null: false
      t.jsonb :value, null: false, default: {}
      t.text :description
      t.timestamps
    end
    add_index :system_configurations, :key, unique: true

    create_table :point_value_histories, id: :uuid do |t|
      t.uuid :admin_id # Nullable, as system might trigger changes
      t.decimal :old_value, precision: 10, scale: 4
      t.decimal :new_value, precision: 10, scale: 4
      t.text :reason
      t.datetime :effective_date, null: false
      t.timestamps
    end
    add_index :point_value_histories, :effective_date
  end
end
