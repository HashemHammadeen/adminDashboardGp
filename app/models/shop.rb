class Shop < ApplicationRecord
  belongs_to :mall
  
  has_many :shop_admins
  has_many :offers
  
  enum :status, { pending: "pending", approved: "approved", active: "active", inactive: "inactive" }, default: "pending"

  scope :active, -> { where(is_active: true) }

  has_and_belongs_to_many :categories
  has_one_attached :logo
  has_one :shop_points_wallet, foreign_key: :shop_id
  has_many :shop_admins
  has_many :receipts
  has_many :transactions
  has_many :earn_transactions
  has_many :redeem_transactions
  has_many :offers
  has_many :offer_redemptions
  has_many :stamps
  has_many :stamp_transactions
  has_many :audit_logs
  has_many :qrs
end