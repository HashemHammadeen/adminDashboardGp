class AddStatusToShops < ActiveRecord::Migration[8.1]
  def change
    add_column :shops, :status, :string
  end
end
