class CreateCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.integer :status
      t.uuid :shop_id

      t.timestamps
    end
    add_index :campaigns, :shop_id
  end
end
