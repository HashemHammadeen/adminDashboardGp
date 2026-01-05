class ShopAdmin < ApplicationRecord
  belongs_to :shop
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :phone, presence: true

  before_validation :set_legacy_password_hash

  private

  def set_legacy_password_hash
    self.password_hash = encrypted_password if password_hash.blank?
    self.password_hash ||= "legacy_placeholder" # Fallback if encrypted_password is not set yet
  end
end