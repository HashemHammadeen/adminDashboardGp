module ShopAdmins
  class BaseController < ApplicationController
    before_action :authenticate_shop_admin!
    
    layout 'shop_admin'

    protected

    def current_shop
      @current_shop ||= current_shop_admin.shop
    end
    helper_method :current_shop
  end
end
