class AddDeviseToShopAdmins < ActiveRecord::Migration[8.1]
  def change
    add_column :shop_admins, :encrypted_password, :string
    add_column :shop_admins, :reset_password_token, :string
    add_column :shop_admins, :reset_password_sent_at, :datetime
    add_column :shop_admins, :remember_created_at, :datetime
  end
end
