class StampTransaction < ApplicationRecord
  self.inheritance_column = :_type_disabled
  
  belongs_to :user
  belongs_to :shop
  belongs_to :stamp
end
