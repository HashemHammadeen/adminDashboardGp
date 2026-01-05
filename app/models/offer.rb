class Offer < ApplicationRecord
  belongs_to :shop
  has_many :offer_redemptions
  def display_value
    # Returns the value from the JSON hash
    val = reward_value["value"]
    reward_type == "discount" ? "#{val}% OFF" : "#{val} Points"
  end
end