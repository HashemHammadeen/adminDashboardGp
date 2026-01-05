class AddDeviseToMallAdmins < ActiveRecord::Migration[8.1]
  def change
    add_column :mall_admins, :encrypted_password, :string
    add_column :mall_admins, :reset_password_token, :string
    add_column :mall_admins, :reset_password_sent_at, :datetime
    add_column :mall_admins, :remember_created_at, :datetime
  end
end
