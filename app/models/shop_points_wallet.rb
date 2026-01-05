class ShopPointsWallet < ApplicationRecord
  self.primary_key = 'shop_id'
  belongs_to :shop, foreign_key: :shop_id
end