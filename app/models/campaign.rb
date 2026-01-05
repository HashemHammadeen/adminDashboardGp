class Campaign < ApplicationRecord
  belongs_to :shop, optional: true # Mall-wide if nil
  
  enum :status, { draft: 0, active: 1, expired: 2 }, default: :draft

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
