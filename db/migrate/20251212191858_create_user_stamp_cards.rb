class CreateUserStampCards < ActiveRecord::Migration[7.0]
  def up
    create_table :user_stamp_cards, id: false do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true, index: false
      t.references :stamp, type: :uuid, null: false, foreign_key: true, index: false
      t.integer :stamps_counter, null: false, default: 0
      t.boolean :is_completed, null: false, default: false
      t.timestamp :last_transaction, null: false
      t.timestamp :completed_at

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    execute "ALTER TABLE user_stamp_cards ADD PRIMARY KEY (user_id, stamp_id);"
    add_index :user_stamp_cards, :is_completed
  end

  def down
    drop_table :user_stamp_cards
  end
end
