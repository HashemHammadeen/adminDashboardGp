module ShopAdmins
  class SessionsController < Devise::SessionsController
    layout 'auth', only: [:new, :create]
  end
end
