class UserPointsBalance < ApplicationRecord
  self.primary_key = "user_id"
  belongs_to :user, foreign_key: :user_id
end