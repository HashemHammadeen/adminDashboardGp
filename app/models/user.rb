class User < ApplicationRecord
  belongs_to :tier
  has_one :user_points_balance, foreign_key: :user_id
  has_many :receipts
  has_many :transactions
  has_many :earn_transactions
  has_many :redeem_transactions
  has_many :offer_redemptions
  has_many :user_stamp_cards
  has_many :stamp_transactions
  has_many :audit_logs
  has_many :qrs
end
