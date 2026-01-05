class Transaction < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :shop, optional: true
  belongs_to :receipt, optional: true
end