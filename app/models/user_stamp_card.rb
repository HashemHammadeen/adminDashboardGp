class UserStampCard < ApplicationRecord
  self.primary_key = [:user_id, :stamp_id]
  belongs_to :user
  belongs_to :stamp
end