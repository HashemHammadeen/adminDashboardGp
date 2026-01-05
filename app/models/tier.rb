class Tier < ApplicationRecord
  has_many :users
  alias_attribute :name, :tier_name
end
