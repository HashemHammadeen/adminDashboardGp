class Stamp < ApplicationRecord
  belongs_to :shop
  has_many :user_stamp_cards
  has_many :stamp_transactions
end