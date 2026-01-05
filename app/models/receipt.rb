class Receipt < ApplicationRecord
  belongs_to :shop
  belongs_to :user
  has_many :transactions
end
