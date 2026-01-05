class CreateQrs < ActiveRecord::Migration[7.0]
  def change
    create_table :qrs, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.references :shop, type: :uuid, foreign_key: true
    end
  end
end