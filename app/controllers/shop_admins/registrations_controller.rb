module ShopAdmins
  class RegistrationsController < Devise::RegistrationsController
    layout 'auth'
  end
end
