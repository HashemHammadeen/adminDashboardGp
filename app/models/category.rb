class Category < ApplicationRecord
  has_and_belongs_to_many :shops
  alias_attribute :name, :category_name

  validates :category_name, presence: true, uniqueness: true

  # Soft delete scope
  # By default, we might show all or just active. Let's decide to show all in admin, but maybe emphasize active.
  # If we want a scope to hide deleted:
  scope :active, -> { where(active: true) }

  def soft_delete
    update(active: false)
  end
end