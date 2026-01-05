class CreateMalls < ActiveRecord::Migration[7.0]
  def change
    create_table :malls, id: :uuid do |t|
      t.string :mall_name, null: false
      t.string :location

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :malls, :mall_name, unique: true
  end
end
