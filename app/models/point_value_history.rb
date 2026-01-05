class PointValueHistory < ApplicationRecord
  # belongs_to :admin, class_name: 'MallAdmin', optional: true # Or ShopAdmin, depending on who changes it. 
  # For now, we'll keep it optional and generic as it could be a system change or different admin types.

  validates :old_value, :new_value, :effective_date, presence: true
end
