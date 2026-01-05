class CreateUserPointsBalances < ActiveRecord::Migration[7.0]
  def up
    create_table :user_points_balances, id: false do |t|
      t.uuid :user_id, null: false
      t.integer :total_points, null: false, default: 0
      t.integer :lifetime_points, null: false, default: 0
      t.timestamp :last_updated, default: -> { 'CURRENT_TIMESTAMP' }
    end

    execute "ALTER TABLE user_points_balances ADD PRIMARY KEY (user_id);"
    add_foreign_key :user_points_balances, :users, column: :user_id

    execute <<-SQL
      COMMENT ON COLUMN user_points_balances.lifetime_points IS 'For tier calculation'
    SQL
  end

  def down
    drop_table :user_points_balances
  end
end