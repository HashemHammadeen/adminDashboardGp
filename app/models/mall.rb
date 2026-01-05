class Mall < ApplicationRecord
  has_many :shops
  has_many :mall_admins
  alias_attribute :name, :mall_name

end