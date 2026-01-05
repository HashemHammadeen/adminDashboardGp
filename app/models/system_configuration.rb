class SystemConfiguration < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  # Helper to get a value with a default
  def self.get(key, default = nil)
    find_by(key: key)&.value || default
  end

  # Helper to set a value
  def self.set(key, value, description = nil)
    config = find_or_initialize_by(key: key)
    config.value = value
    config.description = description if description
    config.save!
  end

  # Specific helpers for known configurations
  def self.point_value
    get('point_value', 0.01).to_f
  end

  def self.expiration_days
    get('expiration_days', 365).to_i
  end
end
