module MallAdmins
  class RegistrationsController < Devise::RegistrationsController
    layout 'auth'
  end
end
